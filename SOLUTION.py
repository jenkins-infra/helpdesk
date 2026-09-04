from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, Optional, Union

@dataclass
class AzureControllerConfig:
    """
    Encapsulates the configuration for the cert.ci.jenkins.io Controller VM.
    Handles migration specifics from Azure CDF to Sponsored Subscription.
    """
    # Identification
    vm_name: str
    resource_group: str
    domain: str = "cert.ci.jenkins.io"
    
    # Compute Specs (D2as_v7 specifics)
    instance_size: str = "Standard_D2as_v7"
    
    # Network Specs (VNet Default NSG + Subnet /24)
    subnet_cidr: int = 24
    vnet_name: str = "vnet-cdf"
    
    # Metadata
    subscription_id: str = "0000-0000-0000"  # Placeholder for Sponsored Sub
    resource_tag: dict = field(default_factory=dict)
    
    # Migration State
    is_migrated: bool = True

    def __post_init__(self):
        # Ensure resource group has a suffix to avoid collisions (as per issue notes)
        if not self.resource_group.endswith("sponsored"):
            self.resource_group += "_sponsored"
            
        # Ensure VM name reflects the migration state
        if "sponsored" in self.resource_group:
            if self.vm_name.startswith("controller"):
                self.vm_name = "controller-sponsored" + self.vm_name.lstrip("controller")

    def get_compute_map(self) -> Dict[str, str]:
        """Generates the Terraform map for the compute resource."""
        return {
            "instance_type": self.instance_size,
            "subnet_cidr": str(self.subnet_cidr),
            "vcpu_cores": 2 if "v7" in self.instance_size else 4,  # Standard D2as_v7 is 2 vCPU
            "memory_gb": 12,  # Standard D2as_v7 is 12GB RAM
        }

    def get_network_map(self) -> Dict[str, str]:
        """Generates the Terraform map for the network resource (Subnet /24)."""
        return {
            "cidr_block": f"10.0.{self.subnet_cidr // 8}.0/24" if self.subnet_cidr >= 18 else f"10.0.0.{self.subnet_cidr}/24",
            "vnet_name": self.vnet_name,
            "ns_g_type": "AzureNetworkInterface", # Reusing VNet Default
        }

    def get_terraform_config(self) -> Dict[str, Union[str, int]]:
        """Aggregates all maps for a 'module' or 'var' file input."""
        config = {
            "name": self.vm_name,
            "resource_group": self.resource_group,
            "instance": self.instance_size,
            "tags": self.resource_tag,
            "zone": "1" if "v7" in self.instance_size else "1", # v7 is often Zonal
            "subnet_size": self.subnet_cidr,
        }
        # Inject specific D2as_v7 quirks
        if "D2as_v7" in self.instance_size:
            config["cpu_count"] = 2
            config["ram_mb"] = 12288
            
        return config

    def snapshot_sync_logic(self, source_path: str, dest_path: str, sync_name: str) -> str:
        """Simulates the rsync command execution mentioned in the issue body."""
        snapshot_base = f"{self.vm_name}_snapshot"
        # The logic for the secondary sync during downtime
        return f"rsync -a --delete {source_path}:{snapshot_base}/ {dest_path}/{sync_name}/"

    def generate_env_vars(self) -> Dict[str, str]:
        """Generates environment variables for the pod/VM context."""
        return {
            "AZURE_SUBSCRIPTION": self.subscription_id,
            "VM_ID": f"{self.resource_group}/{self.vm_name}",
            "VM_FAMILY": "D2as_v7",
            "CONTROLLER_ROLE": "sponsored",
        }


def main():
    # Instantiate the specific config for the new subscription
    controller_config = AzureControllerConfig(
        vm_name="controller.cert.ci.jenkins.io", # Logic will adjust this
        resource_group="rg-cert-ci",
        domain="cert.ci.jenkins.io",
        instance_size="Standard_D2as_v7",
        subnet_cidr=24,
        subscription_id="000000-XXXX-XXXX-XXXX",
        resource_tag={
            "Project": "cert-ci",
            "Environment": "sponsored",
            "Owner": "jenkins-infra"
        }
    )

    # Post-processing the object state
    final_config = controller_config.get_terraform_config()
    env_vars = controller_config.generate_env_vars()
    
    # Simulate the output to verify the fix works
    print(f"Configured VM: {controller_config.vm_name}")
    print(f"Target Family: {final_config['instance']}")
    print(f"Network Mask: {final_config['subnet_size']}/24")

    # Logic to handle the snapshot rsync orchestration
    source_vm = "controller.cert.ci.jenkins.io"
    dest_vm = f"{controller_config.vm_name}"
    
    # Determine if we are in 'sponsored' mode
    is_sponsored = "sponsored" in dest_vm
    
    # Dynamic adjustment for the 'D2as' disk cache logic if needed
    if is_sponsored:
        final_config["ephemeral_storage"] = "128" # D2as usually benefits from larger temp storage
        controller_config.resource_tag["DiskCache"] = "v7"
        
    print(f"Final JSON Payload: {final_config}")

    # Return the object for further piping if this is called in a pipeline
    return controller_config

if __name__ == "__main__":
    main()
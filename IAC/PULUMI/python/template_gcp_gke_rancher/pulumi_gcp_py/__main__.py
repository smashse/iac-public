import pulumi
from pulumi_gcp import compute

network = compute.Network("template-network")

firewall = compute.Firewall(
    "template-firewall",
    network=network.self_link,
    allows=[
        compute.FirewallAllowArgs(
            protocol="tcp",
            ports=["22"]
        ),
        compute.FirewallAllowArgs(
            protocol="tcp",
            ports=["80"]
        ),
        compute.FirewallAllowArgs(
            protocol="tcp",
            ports=["443"]
        ),
        compute.FirewallAllowArgs(
            protocol="tcp",
            ports=["2376"]
        ),
        compute.FirewallAllowArgs(
            protocol="tcp",
            ports=["6443"]
        ),
    ]
)

script = """
#!/bin/bash
sudo echo "#ubuntu
deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu focal-proposed restricted main universe multiverse
#security
deb http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse
#partner
deb http://archive.canonical.com/ubuntu focal partner" > /etc/apt/sources.list
echo "DEBIAN_FRONTEND=noninteractive" >> /etc/environment
source /etc/environment
sudo apt-get update --fix-missing
sudo apt-get -y install snap snapd
source /etc/environment
sudo snap install docker --classic
source /etc/environment
sleep 60; sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /root/docker/rancher:/var/lib/rancher rancher/rancher:stable
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
"""

instance_addr = compute.address.Address("template-rancher")
instance = compute.Instance(
    "template-rancher",
    name="template-rancher",
    machine_type="e2-medium",
    boot_disk=compute.InstanceBootDiskArgs(
        initialize_params=compute.InstanceBootDiskInitializeParamsArgs(
            image="ubuntu-os-cloud/ubuntu-2004-lts"
        ),
    ),
    network_interfaces=[
        compute.InstanceNetworkInterfaceArgs(
            network=network.id,
            access_configs=[compute.InstanceNetworkInterfaceAccessConfigArgs(
                nat_ip=instance_addr.address
            )]
        )
    ],
    metadata_startup_script=script,
)

pulumi.export("instance_name", instance.name)
pulumi.export("instance_external_ip", instance_addr.address)

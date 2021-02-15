import pulumi
import pulumi_aws as aws
from pulumi_aws import ec2, get_availability_zones

zones = get_availability_zones()
subnet_ids = []

# Default VPC
template_default_vpc = aws.ec2.Vpc("templateDefaultVpc",
    cidr_block="10.0.0.0/16",
    enable_dns_hostnames=True,
    enable_dns_support=True,
    instance_tenancy="default",
    tags={
        "Name": "template-default-vpc",
    })

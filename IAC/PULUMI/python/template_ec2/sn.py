import pulumi
import pulumi_aws as aws

import vpc

available = aws.get_availability_zones(state="available")

# Public Subnet A and B
template_public_subnet_a = aws.ec2.Subnet("templatePublicSubnetA",
    vpc_id=vpc.template_default_vpc.id,
    cidr_block="10.0.1.0/24",
    availability_zone=available.names[0],
    map_public_ip_on_launch=True,
    tags={
        "Name": "template-public-subnet-a",
    })
template_public_subnet_b = aws.ec2.Subnet("templatePublicSubnetB",
    vpc_id=vpc.template_default_vpc.id,
    cidr_block="10.0.2.0/24",
    availability_zone=available.names[1],
    map_public_ip_on_launch=True,
    tags={
        "Name": "template-public-subnet-b",
    })

# Private Subnet A and B
template_private_subnet_a = aws.ec2.Subnet("templatePrivateSubnetA",
    vpc_id=vpc.template_default_vpc.id,
    cidr_block="10.0.10.0/24",
    availability_zone=available.names[0],
    map_public_ip_on_launch=False,
    tags={
        "Name": "template-private-subnet-a",
    })
template_private_subnet_b = aws.ec2.Subnet("templatePrivateSubnetB",
    vpc_id=vpc.template_default_vpc.id,
    cidr_block="10.0.20.0/24",
    availability_zone=available.names[1],
    map_public_ip_on_launch=False,
    tags={
        "Name": "template-private-subnet-b",
    })

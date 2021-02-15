import pulumi
import pulumi_aws as aws

import igw
import nat
import vpc

# Route Table internet Gateway
template_default_igw_rtb = aws.ec2.RouteTable("templateDefaultIgwRtb",
    vpc_id=vpc.template_default_vpc.id,
    tags={
        "Name": "template-default-igw-rtb",
    })

# Route for Route Table internet Gateway
template_default_igw_rt = aws.ec2.Route("templateDefaultIgwRt",
    route_table_id=template_default_igw_rtb.id,
    destination_cidr_block="0.0.0.0/0",
    gateway_id=igw.template_default_igw.id)

# Route Table NAT Gateway
template_default_nat_gw_rtb = aws.ec2.RouteTable("templateDefaultNatGwRtb",
    vpc_id=vpc.template_default_vpc.id,
    tags={
        "Name": "template-default-nat-gw-rtb",
    })

# Route for Route Table NAT Gateway
template_default_nat_gw_rt = aws.ec2.Route("templateDefaultNatGwRt",
    route_table_id=template_default_nat_gw_rtb.id,
    destination_cidr_block="0.0.0.0/0",
    nat_gateway_id=nat.template_default_nat_gw.id)

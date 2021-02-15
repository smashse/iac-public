import pulumi
import pulumi_aws as aws

import eip
import sn

# Default NAT Gateway
template_default_nat_gw = aws.ec2.NatGateway("templateDefaultNatGw",
    allocation_id=eip.template_default_eip.id,
    subnet_id=sn.template_public_subnet_a.id,
    tags={
        "Name": "template-default-nat-gw",
    },
    )


import pulumi
import pulumi_aws as aws

import sn
import vpc

# Default Network ACL
template_default_acl = aws.ec2.DefaultNetworkAcl("templateDefaultAcl",
    default_network_acl_id=vpc.template_default_vpc.default_network_acl_id,
    subnet_ids=[
        sn.template_public_subnet_a.id,
        sn.template_public_subnet_b.id,
        sn.template_private_subnet_a.id,
        sn.template_private_subnet_b.id,
    ],
    ingress=[{
        "from_port": 0,
        "to_port": 0,
        "ruleNo": 100,
        "action": "allow",
        "protocol": "-1",
        "cidr_block": "0.0.0.0/0",
    }],
    egress=[{
        "from_port": 0,
        "to_port": 0,
        "ruleNo": 100,
        "action": "allow",
        "protocol": "-1",
        "cidr_block": "0.0.0.0/0",
    }],
    tags={
        "Name": "template-default-acl",
    })


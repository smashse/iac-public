import pulumi
import pulumi_aws as aws

import vpc

# Default Security Group
template_default_sg = aws.ec2.SecurityGroup("templateDefaultSg",
    description="template-default-sg",
    vpc_id=vpc.template_default_vpc.id,
    ingress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "security_groups": [],
        "self": True,
    }],
    egress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    tags={
        "Name": "template-default-sg",
    })

# Default Security Group for SSH
template_default_ssh = aws.ec2.SecurityGroup("templateDefaultSsh",
    description="template-default-ssh",
    vpc_id=vpc.template_default_vpc.id,
    ingress=[{
        "description": "SSH",
        "from_port": 22,
        "to_port": 22,
        "protocol": "tcp",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    egress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    tags={
        "Name": "template-default-ssh",
    })

# Default Security Group for POC
template_default_poc = aws.ec2.SecurityGroup("templateDefaultPoc",
    description="template-default-poc",
    vpc_id=vpc.template_default_vpc.id,
    ingress=[
        {
            "description": "HTTP",
            "from_port": 80,
            "to_port": 80,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "HTTP",
            "from_port": 8080,
            "to_port": 8080,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "HTTPS",
            "from_port": 443,
            "to_port": 443,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "MICROK8S",
            "from_port": 16443,
            "to_port": 16443,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "ALL",
            "from_port": 0,
            "to_port": 0,
            "protocol": "-1",
            "cidr_blocks": ["0.0.0.0/0"],
        },
    ],
    egress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    tags={
        "Name": "template-default-poc",
    })

# Default Security Group for Load Balancer
template_default_lb = aws.ec2.SecurityGroup("templateDefaultLb",
    description="template-default-lb",
    vpc_id=vpc.template_default_vpc.id,
    ingress=[
        {
            "description": "HTTP",
            "from_port": 80,
            "to_port": 80,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "HTTPS",
            "from_port": 443,
            "to_port": 443,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "ALL",
            "from_port": 0,
            "to_port": 65535,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
    ],
    egress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    tags={
        "Name": "template-default-lb",
    })

# Default Security Group for Private Instances
template_private_sg_all = aws.ec2.SecurityGroup("templatePrivateSgAll",
    description="template-private-sg-all",
    vpc_id=vpc.template_default_vpc.id,
    ingress=[
        {
            "description": "SSH",
            "from_port": 22,
            "to_port": 22,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "DOCKER",
            "from_port": 2376,
            "to_port": 2376,
            "protocol": "tcp",
            "cidr_blocks": ["0.0.0.0/0"],
        },
        {
            "description": "ALL",
            "from_port": 0,
            "to_port": 0,
            "protocol": "-1",
            "cidr_blocks": ["0.0.0.0/0"],
        },
    ],
    egress=[{
        "description": "ALL",
        "from_port": 0,
        "to_port": 0,
        "protocol": "-1",
        "cidr_blocks": ["0.0.0.0/0"],
    }],
    tags={
        "Name": "template-private-sg-all",
    })

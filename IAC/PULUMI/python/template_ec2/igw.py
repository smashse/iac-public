import pulumi
import pulumi_aws as aws

import vpc

# Deafualt Internet Gateway
template_default_igw = aws.ec2.InternetGateway("templateDefaultIgw",
    vpc_id=vpc.template_default_vpc.id,
    tags={
        "Name": "template-default-igw",
    })

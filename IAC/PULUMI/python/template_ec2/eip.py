import pulumi
import pulumi_aws as aws

import ec2_public

# Default Elastic IP
template_default_eip = aws.ec2.Eip("templateDefaultEip",
    vpc=True,
    tags={
        "Name": "template-default-eip",
    })

# Elastic IP for Bastion Instance
template_instance_bastion_eip = aws.ec2.Eip("templateInstanceBastionEip",
    vpc=True,
    instance=ec2_public.template_instance_bastion.id,
    tags={
        "Name": "template-instance-bastion-eip",
    })

# Elastic IP for America Instance
# template_instance_america_eip = aws.ec2.Eip("templateInstanceAmericaEip",
#     vpc=True,
#     instance=ec2_public.template_instance_america.id,
#     tags={
#         "Name": "template-instance-america-eip",
#     })

# Elastic IP for Europa Instance
# template_instance_europa_eip = aws.ec2.Eip("templateInstanceEuropaEip",
#     vpc=True,
#     instance=ec2_public.template_instance_europa.id,
#     tags={
#         "Name": "template-instance-europa-eip",
#     })

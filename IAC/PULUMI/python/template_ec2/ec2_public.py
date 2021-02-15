import pulumi
import pulumi_aws as aws

import igw
import sg
import sn
import vpc

# Public Instance for Bastion
template_instance_bastion = aws.ec2.Instance("templateInstanceBastion",
    ami="ami-0885b1f6bd170450c",
    availability_zone="us-east-1a",
    ebs_optimized=False,
    instance_type="t2.micro",
    monitoring=True,
    key_name="pulumi_ec2_py_access",
    subnet_id=sn.template_public_subnet_a.id,
    vpc_security_group_ids=[sg.template_default_ssh.id],
    associate_public_ip_address=True,
    private_ip="10.0.1.10",
    source_dest_check=True,
    user_data=(lambda path: open(path).read())("./cloud_init/cloud-init-generic.conf"),
    root_block_device={
        "volumeType": "gp2",
        "volume_size": 16,
        "deleteOnTermination": True,
    },
    tags={
        "Name": "template-instance-bastion",
    },
    )

# Public Instance for America
# template_instance_america = aws.ec2.Instance("templateInstanceAmerica",
#     ami="ami-0885b1f6bd170450c",
#     availability_zone="us-east-1a",
#     ebs_optimized=False,
#     instance_type="t2.medium",
#     monitoring=True,
#     key_name="pulumi_ec2_py_access",
#     subnet_id=sn.template_public_subnet_a.id,
#     vpc_security_group_ids=[sg.template_default_ssh.id, sg.template_default_poc.id],
#     associate_public_ip_address=True,
#     private_ip="10.0.1.11",
#     source_dest_check=True,
#     user_data=(lambda path: open(path).read())("./cloud_init/cloud-init-microk8s.conf"),
#     root_block_device={
#         "volumeType": "gp2",
#         "volume_size": 16,
#         "deleteOnTermination": True,
#     },
#     tags={
#         "Name": "template-instance-america",
#     },
#     )

# Public Instance for Europa
# template_instance_europa = aws.ec2.Instance("templateInstanceEuropa",
#     ami="ami-0885b1f6bd170450c",
#     availability_zone="us-east-1a",
#     ebs_optimized=False,
#     instance_type="t2.medium",
#     monitoring=True,
#     key_name="pulumi_ec2_py_access",
#     subnet_id=sn.template_public_subnet_a.id,
#     vpc_security_group_ids=[sg.template_default_ssh.id, sg.template_default_poc.id],
#     associate_public_ip_address=True,
#     private_ip="10.0.1.12",
#     source_dest_check=True,
#     user_data=(lambda path: open(path).read())("./cloud_init/cloud-init-microk8s.conf"),
#     root_block_device={
#         "volumeType": "gp2",
#         "volume_size": 16,
#         "deleteOnTermination": True,
#     },
#     tags={
#         "Name": "template-instance-europa",
#     },
#     )

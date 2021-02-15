import pulumi
import pulumi_aws as aws

import igw
import sg
import sn
import vpc

# Public Instance
template_instance_private = aws.ec2.Instance("templateInstancePrivate",
    ami="ami-0885b1f6bd170450c",
    availability_zone="us-east-1a",
    ebs_optimized=False,
    instance_type="t2.micro",
    monitoring=True,
    key_name="pulumi_ec2_py_access",
    subnet_id=sn.template_private_subnet_a.id,
    vpc_security_group_ids=[sg.template_private_sg_all.id],
    associate_public_ip_address=False,
    private_ip="10.0.10.10",
    source_dest_check=True,
    user_data=(lambda path: open(path).read())("./cloud_init/cloud-init-generic.conf"),
    root_block_device={
        "volumeType": "gp2",
        "volume_size": 16,
        "deleteOnTermination": True,
    },
    tags={
        "Name": "template-instance-private",
    },
    )

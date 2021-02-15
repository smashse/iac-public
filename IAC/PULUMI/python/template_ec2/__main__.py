import pulumi
import pulumi_aws as aws

import dynamodb
# import ec2_private
import ec2_public
import eip
import igw
import nacl
import nat
import rt
import rta
import s3
import sg
import sn
import vpc

pulumi.export('bastion_id', ec2_public.template_instance_bastion.id)
pulumi.export('bastion_pub_ip', ec2_public.template_instance_bastion.public_ip)
pulumi.export('bastion_priv_ip', ec2_public.template_instance_bastion.private_ip)
pulumi.export('bastion_dns', ec2_public.template_instance_bastion.public_dns)

# pulumi.export('america_id', ec2_public.template_instance_america.id)
# pulumi.export('america_pub_ip', ec2_public.template_instance_america.public_ip)
# pulumi.export('america_priv_ip', ec2_public.template_instance_america.private_ip)
# pulumi.export('america_dns', ec2_public.template_instance_america.public_dns)

# pulumi.export('europa_id', ec2_public.template_instance_europa.id)
# pulumi.export('europa_pub_ip', ec2_public.template_instance_europa.public_ip)
# pulumi.export('europa_priv_ip', ec2_public.template_instance_europa.private_ip)
# pulumi.export('europa_dns', ec2_public.template_instance_europa.public_dns)

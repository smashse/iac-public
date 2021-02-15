import pulumi
import pulumi_aws as aws

import rt
import sn

# Route Table Association Public A and B
template_public_a_rtb_rtbassoc = aws.ec2.RouteTableAssociation("templatePublicARtbRtbassoc",
    route_table_id=rt.template_default_igw_rtb.id,
    subnet_id=sn.template_public_subnet_a.id)

template_public_b_rtb_rtbassoc = aws.ec2.RouteTableAssociation("templatePublicBRtbRtbassoc",
    route_table_id=rt.template_default_igw_rtb.id,
    subnet_id=sn.template_public_subnet_b.id)

# Route Table Association Private A and B
template_private_a_rtb_rtbassoc = aws.ec2.RouteTableAssociation("templatePrivateARtbRtbassoc",
    route_table_id=rt.template_default_nat_gw_rtb.id,
    subnet_id=sn.template_private_subnet_a.id)

template_private_b_rtb_rtbassoc = aws.ec2.RouteTableAssociation("templatePrivateBRtbRtbassoc",
    route_table_id=rt.template_default_nat_gw_rtb.id,
    subnet_id=sn.template_private_subnet_b.id)


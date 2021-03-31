import pulumi
import pulumi_aws as aws

import lightsail_key_pair
import var

template_instance = aws.lightsail.Instance("templateInstance",
    name="template_instance",
    availability_zone=var.aws_zone_id[var.aws_region],
    blueprint_id=var.aws_blueprint_id["amazon"],
    bundle_id=var.aws_bundle_id["micro"],
    key_pair_name=var.ssh_key_pair_name,
    user_data=(lambda path: open(path).read())("./cloud_init/amazon-generic.sh"),
    tags={
        "Name": "template-instance",
    },
    )
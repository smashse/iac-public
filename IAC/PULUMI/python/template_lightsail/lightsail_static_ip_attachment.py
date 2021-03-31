import pulumi
import pulumi_aws as aws

import lightsail_static_ip
import lightsail_public_instance

template_attachment = aws.lightsail.StaticIpAttachment("templateAttachment",
    static_ip_name=lightsail_static_ip.template_ip.id,
    instance_name=lightsail_public_instance.template_instance.id)

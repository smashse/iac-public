import pulumi
import pulumi_aws as aws

template_ip = aws.lightsail.StaticIp("templateIp", name="template_ip")

import pulumi
import pulumi_aws as aws

template_domain = aws.lightsail.Domain("templateDomain", domain_name="template.com")
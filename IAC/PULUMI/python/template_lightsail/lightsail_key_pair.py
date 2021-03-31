import pulumi
import pulumi_aws as aws

template_access = aws.lightsail.KeyPair("templateAccess", name="template_access", public_key=(lambda path: open(path).read())("./template_access.pub"))
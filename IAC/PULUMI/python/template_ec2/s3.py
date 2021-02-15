import pulumi
import pulumi_aws as aws

# S3 Bucket
templatestate_template = aws.s3.Bucket("templatestateTemplate",
    acl="private",
    force_destroy=True,
    versioning={
        "enabled": False,
    },
    server_side_encryption_configuration={
        "rule": {
            "applyServerSideEncryptionByDefault": {
                "sseAlgorithm": "AES256",
            },
        },
    })

# S3 Bucket Object
template = aws.s3.BucketObject("template",
    bucket=templatestate_template.id,
    acl="private",
    key="template/vpc/",
    source=pulumi.FileAsset("/dev/null"))


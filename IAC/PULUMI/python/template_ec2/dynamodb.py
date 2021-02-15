import pulumi
import pulumi_aws as aws

template_state_lock = aws.dynamodb.Table("templateStateLock",
    attributes=[{
        "name": "LockID",
        "type": "S",
    }],
    hash_key="LockID",
    read_capacity=10,
    write_capacity=10)
import pulumi

config = pulumi.Config()
aws_region = config.get("awsRegion")
if aws_region is None:
    aws_region = "us-east-1"
aws_profile = config.get("awsProfile")
if aws_profile is None:
    aws_profile = "template"
aws_zone_id = config.get_object("awsZoneId")
if aws_zone_id is None:
    aws_zone_id = {
        "us-east-1": "us-east-1a",
        "us-east-2": "us-east-2a",
    }
aws_blueprint_id = config.get_object("awsBlueprintId")
if aws_blueprint_id is None:
    aws_blueprint_id = {
        "amazon": "amazon_linux_2",
        "centos": "centos_7_1901_01",
        "opensuse": "opensuse_15_1",
        "debian": "debian_10",
        "ubuntu": "ubuntu_20_04",
    }
aws_bundle_id = config.get_object("awsBundleId")
if aws_bundle_id is None:
    aws_bundle_id = {
        "nano": "nano_2_0",
        "micro": "micro_2_0",
        "small": "small_2_0",
        "medium": "medium_2_0",
        "large": "large_2_0",
        "xlarge": "xlarge_2_0",
        "2xlarge": "2xlarge_2_0",
    }
ssh_key_pair_name = config.get("sshKeyPairName")
if ssh_key_pair_name is None:
    ssh_key_pair_name = "template_access"

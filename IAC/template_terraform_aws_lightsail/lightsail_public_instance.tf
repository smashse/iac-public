resource "aws_lightsail_instance" "template_instance" {
  name              = "template-instance"
  availability_zone = var.aws_zone_id[var.aws_region]
  blueprint_id      = var.aws_blueprint_id.amazon
  bundle_id         = var.aws_bundle_id
  key_pair_name     = var.ssh_key_pair_name
  user_data         = file("./cloud_init/amazon-generic.sh")
  depends_on        = [aws_lightsail_key_pair.template_access]

  tags = {
    Name = "template-instance"
  }
}

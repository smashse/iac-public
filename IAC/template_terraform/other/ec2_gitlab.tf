# Private Instance for Gitlab
resource "aws_instance" "template_instance_gitlab" {
  ami                         = var.aws_image_id[var.aws_region]
  availability_zone           = var.aws_zone_id[var.aws_region]
  ebs_optimized               = false
  instance_type               = var.instance_type
  monitoring                  = true
  key_name                    = var.ssh_key_pair_name
  subnet_id                   = aws_subnet.template_private_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.template_private_sg_all.id]
  associate_public_ip_address = false
  private_ip                  = "10.0.10.70"
  source_dest_check           = true
  user_data                   = file("./cloud_init/cloud-init-gitlab.conf")
  depends_on                  = [aws_nat_gateway.template_default_nat_gw]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }

  tags = {
    Name = "template-instance-gitlab"
  }
}

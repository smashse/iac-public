#resource "aws_instance" "template_instance_public" {
#  ami                         = var.aws_image_id[var.aws_region]
#  availability_zone           = var.aws_zone_id[var.aws_region]
#  ebs_optimized               = false
#  instance_type               = "t2.micro"
#  monitoring                  = true
#  key_name                    = var.ssh_key_pair_name
#  subnet_id                   = aws_subnet.template_public_subnet_a.id
#  vpc_security_group_ids      = [aws_security_group.template_default_ssh.id]
#  associate_public_ip_address = true
#  private_ip                  = "10.0.1.10"
#  source_dest_check           = true
#  user_data                   = file("./cloud_init/cloud-init-generic.conf")
#  depends_on                  = [aws_internet_gateway.template_default_igw]
#
#  root_block_device {
#    volume_type           = "gp2"
#    volume_size           = 16
#    delete_on_termination = true
#  }
#
#  tags = {
#    Name = "template-instance-public"
#  }
#}

# Public Instance for Bastion
resource "aws_instance" "template_instance_bastion" {
  ami                         = var.aws_image_id[var.aws_region]
  availability_zone           = var.aws_zone_id[var.aws_region]
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = var.ssh_key_pair_name
  subnet_id                   = aws_subnet.template_public_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.template_default_ssh.id]
  associate_public_ip_address = true
  private_ip                  = "10.0.1.10"
  source_dest_check           = true
  user_data                   = file("./cloud_init/cloud-init-generic.conf")
  depends_on                  = [aws_internet_gateway.template_default_igw]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 16
    delete_on_termination = true
  }

  tags = {
    Name = "template-instance-bastion"
  }
}

# Default Elastic IP
resource "aws_eip" "template_default_eip" {
  vpc = true

  tags = {
    Name = "template-default-eip"
  }
}

# Elastic IP for Bastion Instance
resource "aws_eip" "template_instance_bastion_eip" {
  vpc      = true
  instance = aws_instance.template_instance_bastion.id

  tags = {
    Name = "template-instance-bastion-eip"
  }
}

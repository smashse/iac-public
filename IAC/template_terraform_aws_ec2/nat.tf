# Default NAT Gateway
resource "aws_nat_gateway" "template_default_nat_gw" {
  allocation_id = aws_eip.template_default_eip.id
  subnet_id     = aws_subnet.template_public_subnet_a.id
  depends_on    = [aws_eip.template_default_eip, aws_subnet.template_public_subnet_a]

  tags = {
    Name = "template-default-nat-gw"
  }
}

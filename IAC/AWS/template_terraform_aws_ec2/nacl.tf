# Default Network ACL
resource "aws_default_network_acl" "template_default_acl" {
  default_network_acl_id = aws_vpc.template_default_vpc.default_network_acl_id
  subnet_ids             = [aws_subnet.template_public_subnet_a.id, aws_subnet.template_public_subnet_b.id, aws_subnet.template_private_subnet_a.id, aws_subnet.template_private_subnet_b.id]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "template-default-acl"
  }
}

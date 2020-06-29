# Route Table Association Public A and B
resource "aws_route_table_association" "template_public_a_rtb_rtbassoc" {
  route_table_id = aws_route_table.template_default_igw_rtb.id
  subnet_id      = aws_subnet.template_public_subnet_a.id
}

resource "aws_route_table_association" "template_public_b_rtb_rtbassoc" {
  route_table_id = aws_route_table.template_default_igw_rtb.id
  subnet_id      = aws_subnet.template_public_subnet_b.id
}

# Route Table Association Private A and B
resource "aws_route_table_association" "template_private_a_rtb_rtbassoc" {
  route_table_id = aws_route_table.template_default_nat_gw_rtb.id
  subnet_id      = aws_subnet.template_private_subnet_a.id
}

resource "aws_route_table_association" "template_private_b_rtb_rtbassoc" {
  route_table_id = aws_route_table.template_default_nat_gw_rtb.id
  subnet_id      = aws_subnet.template_private_subnet_b.id
}

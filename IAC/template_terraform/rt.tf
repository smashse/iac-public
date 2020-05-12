# Route Table internet Gateway
resource "aws_route_table" "template_default_igw_rtb" {
  vpc_id = aws_vpc.template_default_vpc.id

  tags = {
    Name = "template-default-igw-rtb"
  }
}

# Route for Route Table internet Gateway
resource "aws_route" "template_default_igw_rt" {
  route_table_id         = aws_route_table.template_default_igw_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.template_default_igw.id
}

# Route Table NAT Gateway
resource "aws_route_table" "template_default_nat_gw_rtb" {
  vpc_id = aws_vpc.template_default_vpc.id

  tags = {
    Name = "template-default-nat-gw-rtb"
  }
}

# Route for Route Table NAT Gateway
resource "aws_route" "template_default_nat_gw_rt" {
  route_table_id         = aws_route_table.template_default_nat_gw_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.template_default_nat_gw.id
}

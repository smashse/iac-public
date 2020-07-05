# Deafualt Internet Gateway
resource "aws_internet_gateway" "template_default_igw" {
  vpc_id = aws_vpc.template_default_vpc.id

  tags = {
    Name = "template-default-igw"
  }
}

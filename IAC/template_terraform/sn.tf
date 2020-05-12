# Public Subnet A and B
resource "aws_subnet" "template_public_subnet_a" {
  vpc_id                  = aws_vpc.template_default_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "template-public-subnet-a"
  }
}

resource "aws_subnet" "template_public_subnet_b" {
  vpc_id                  = aws_vpc.template_default_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "template-public-subnet-b"
  }
}

# Private Subnet A and B
resource "aws_subnet" "template_private_subnet_a" {
  vpc_id                  = aws_vpc.template_default_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "template-private-subnet-a"
  }
}

resource "aws_subnet" "template_private_subnet_b" {
  vpc_id                  = aws_vpc.template_default_vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "template-private-subnet-b"
  }
}

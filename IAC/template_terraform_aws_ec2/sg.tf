# Default Security Group
resource "aws_security_group" "template_default_sg" {
  name        = "template-default-sg"
  description = "template-default-sg"
  vpc_id      = aws_vpc.template_default_vpc.id

  ingress {
    description     = "ALL"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = []
    self            = true
  }

  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "template-default-sg"
  }
}

# Default Security Group for SSH
resource "aws_security_group" "template_default_ssh" {
  name        = "template-default-ssh"
  description = "template-default-ssh"
  vpc_id      = aws_vpc.template_default_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "template-default-ssh"
  }
}

# Default Security Group for Load Balancer
resource "aws_security_group" "template_default_lb" {
  name        = "template-default-lb"
  description = "template-default-lb"
  vpc_id      = aws_vpc.template_default_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "template-default-lb"
  }
}

# Default Security Group for Private Instances
resource "aws_security_group" "template_private_sg_all" {
  name        = "template-private-sg-all"
  description = "template-private-sg-all"
  vpc_id      = aws_vpc.template_default_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "DOCKER"
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "template-private-sg-all"
  }
}

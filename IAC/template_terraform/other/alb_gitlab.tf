# Application Load Balancer for Gitlab
resource "aws_alb" "gitlab" {
  name               = "gitlab"
  idle_timeout       = 60
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.template_default_lb.id]
  subnets            = [aws_subnet.template_public_subnet_a.id, aws_subnet.template_public_subnet_b.id]

  enable_deletion_protection = false

  tags = {
    Name = "gitlab"
  }
}

# Application Load Balancer Target Group Port 80 for Gitlab
resource "aws_alb_target_group" "gitlab_http_80" {
  name        = "gitlab-http-80"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.template_default_vpc.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "gitlab-http-80"
  }
}

# Application Load Balancer Target Group Port 443 for Gitlab
resource "aws_alb_target_group" "gitlab_http_443" {
  name        = "gitlab-http-443"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.template_default_vpc.id

  health_check {
    protocol            = "HTTPS"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "gitlab-http-443"
  }
}

# Application Load Balancer Listener Port 80 for Gitlab
resource "aws_alb_listener" "gitlab_http_alb_listener_80" {
  load_balancer_arn = aws_alb.gitlab.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.gitlab_http_80.arn
  }
}

# Application Load Balancer Listener Port 443 for Gitlab
resource "aws_alb_listener" "gitlab_http_alb_listener_443" {
  load_balancer_arn = aws_alb.gitlab.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"
  certificate_arn   = var.aws_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.gitlab_http_443.arn
  }
}

# Application Load Balancer Listener Port 80 for Gitlab
resource "aws_alb_target_group_attachment" "gitlab_http_80_alb_tga" {
  target_group_arn = aws_alb_target_group.gitlab_http_80.arn
  target_id        = aws_instance.template_instance_gitlab.id
  port             = 80
}

# Application Load Balancer Listener Port 443 for Gitlab
resource "aws_alb_target_group_attachment" "gitlab_http_443_alb_tga" {
  target_group_arn = aws_alb_target_group.gitlab_http_443.arn
  target_id        = aws_instance.template_instance_gitlab.id
  port             = 443
}

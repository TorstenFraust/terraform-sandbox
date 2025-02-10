#  all configuration for network resources will be done here like VPC, Subnet, Security Group etc.

module "simple_webserver_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "simple_webserver_vpc"
  cidr = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    owner = "torsten"
  }
}

resource "aws_security_group" "simple_webserver_security_group" {
  name        = "simple_webserver_security_group"
  description = "Security group for simple_webserver"
  vpc_id      = module.simple_webserver_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    owner = "torsten"
  }
}

resource "aws_security_group" "simple_webserver_lb_security_group" {
  name        = "simple_webserver_lb_security_group"
  description = "Security group for the load balancer"
  vpc_id      = module.simple_webserver_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    owner = "torsten"
  }
}


# all configuration for the load balancer will be done here

resource "aws_lb" "simple_webserver_lb" {
  name               = "simple-webserver-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.simple_webserver_vpc.public_subnets
  security_groups    = [aws_security_group.simple_webserver_lb_security_group.id]

  tags = {
    owner = "torsten"
  }
}

resource "aws_lb_target_group" "simple_webserver_target_group" {
  name        = "simple-webserver-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.simple_webserver_vpc.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
  }

  tags = {
    owner = "torsten"
  }
}

resource "aws_lb_listener" "simple_webserver_aws_lb_listener" {
  load_balancer_arn = aws_lb.simple_webserver_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple_webserver_target_group.arn
  }
  tags = {
    owner = "torsten"
  }
}

resource "aws_lb_listener_rule" "simple-webserver" {
  listener_arn = aws_lb_listener.simple_webserver_aws_lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple_webserver_target_group.arn
  }

  condition {
    host_header {
      values = ["simple-webserver.tlservers.net"]
    }
  }
    tags = {
    owner = "torsten"
  }
}
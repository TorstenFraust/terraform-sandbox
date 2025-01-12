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

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.simple_webserver_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.simple_webserver_target_group.arn
  }
}
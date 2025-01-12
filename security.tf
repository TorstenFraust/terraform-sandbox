# all configuration related to security groups will be done here like inbound and outbound rules

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
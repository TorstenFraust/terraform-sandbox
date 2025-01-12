# All configurations for ECS will be done here like cluster, task definition, service etc.

resource "aws_ecs_service" "simple_webserver_service" {
  name            = "simple_webserver-service"
  cluster         = aws_ecs_cluster.simple_webserver_cluster.id
  task_definition = aws_ecs_task_definition.simple_webserver_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.simple_webserver_vpc.public_subnets
    security_groups  = [aws_security_group.simple_webserver_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.simple_webserver_target_group.arn
    container_name   = "simple_webserver"
    container_port   = 80
  }
  tags = {
    owner = "torsten"
  }
}
resource "aws_ecs_cluster" "simple_webserver_cluster" {
  name = "simple_webserver_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Owner = "torsten"
  }
}

resource "aws_ecs_task_definition" "simple_webserver_task" {
  family                   = "simple_webserver_task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "simple_webserver"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
    tags = {
        owner = "torsten"
  }
}
# All configurations for ECS will be done here like cluster, task definition, service etc.

resource "aws_ecs_service" "simple_webserver_service" {
  name            = "simple_webserver-service"
  cluster         = aws_ecs_cluster.simple_webserver_cluster.id
  task_definition = aws_ecs_task_definition.simple_webserver_task.arn
  desired_count   = 1
  enable_execute_command = true

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
    owner = "torsten"
  }
}

resource "aws_ecs_task_definition" "simple_webserver_task" {
  family                   = "simple_webserver_task"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = aws_iam_role.ecs_task_role.arn
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


# Task Role for ssh into the ecs task
resource "aws_iam_role" "ecs_task_role" {
  name = "simple_webserver_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    owner = "torsten"
  }
}

# SSM permissions for ECS Exec
resource "aws_iam_role_policy" "ecs_exec_policy" {
  name = "ecs_exec_policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}
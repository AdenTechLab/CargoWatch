
resource "aws_ecs_cluster" "cargowatch" {
  name = "cargowatch-cluster"

  tags = {
    Name = "CargoWatch ECS Cluster"
  }
}

resource "aws_cloudwatch_log_group" "cargowatch" {
  name              = "/ecs/cargowatch"
  retention_in_days = 7

  tags = {
    Name = "CargoWatch Logs"
  }
}

resource "aws_iam_role" "ecs_execution" {
  name = "CargoWatch-ECS-Execution-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "CargoWatch ECS Execution Role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "cargowatch" {
  family                   = "cargowatch"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "cargowatch"
      image = "${aws_ecr_repository.cargowatch.repository_url}@sha256:e07c1278c2b1b80513b9e949529653483c68008cb76bc93674f67953596b4c3a"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.cargowatch.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "CargoWatch Task Definition"
  }
}

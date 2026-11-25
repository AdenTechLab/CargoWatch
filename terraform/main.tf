
import {
  to = aws_ecr_repository.cargowatch
  id = "cargowatch"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "cargowatch" {
  name                 = var.project_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "CargoWatch ECR"
  }
}

resource "aws_ecr_lifecycle_policy" "cargowatch" {
  repository = aws_ecr_repository.cargowatch.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep the 5 most recent images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS deployment region"
  value       = var.aws_region
}

output "ecr_repository_url" {
  description = "CargoWatch ECR repository URL"
  value       = aws_ecr_repository.cargowatch.repository_url
}

output "ecs_cluster_name" {
  description = "CargoWatch ECS cluster name"
  value       = aws_ecs_cluster.cargowatch.name
}

output "ecs_task_definition_arn" {
  description = "CargoWatch ECS task definition ARN"
  value       = aws_ecs_task_definition.cargowatch.arn
}

output "cloudwatch_log_group" {
  description = "CargoWatch CloudWatch log group"
  value       = aws_cloudwatch_log_group.cargowatch.name
}


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

output "vpc_id" {
  description = "CargoWatch VPC ID"
  value       = aws_vpc.cargowatch.id
}

output "public_subnet_ids" {
  description = "CargoWatch public subnet IDs"
  value = [
    aws_subnet.cargowatch_public_a.id,
    aws_subnet.cargowatch_public_b.id
  ]
}

output "internet_gateway_id" {
  description = "CargoWatch Internet Gateway ID"
  value       = aws_internet_gateway.cargowatch.id
}

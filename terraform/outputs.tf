
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

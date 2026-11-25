
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "cargowatch"
}

variable "allowed_ip" {
  description = "Approved public IP address for CargoWatch access"
  type        = string
}
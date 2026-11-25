
# AWS-managed S3 prefix list for the current region
data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}

# CargoWatch application security group
resource "aws_security_group" "cargowatch" {
  name        = "cargowatch-security-group"
  description = "Restrict CargoWatch access to the approved IP"
  vpc_id      = aws_vpc.cargowatch.id

  ingress {
    description = "Allow CargoWatch access from approved IP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [trimspace(var.allowed_ip)]
  }

  egress = []

  tags = {
    Name = "CargoWatch Security Group"
  }
}

# Allow HTTPS traffic to private AWS endpoints inside the VPC
resource "aws_security_group_rule" "cargowatch_egress_vpc" {
  type              = "egress"
  description       = "Allow HTTPS to private VPC endpoints"
  security_group_id = aws_security_group.cargowatch.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.cargowatch.cidr_block]
}

# Allow HTTPS access to the regional S3 service prefix list
resource "aws_security_group_rule" "cargowatch_egress_s3" {
  type              = "egress"
  description       = "Allow HTTPS to S3 for ECR image layers"
  security_group_id = aws_security_group.cargowatch.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_prefix_list.s3.id]
}

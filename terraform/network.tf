
resource "aws_vpc" "cargowatch" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cargowatch-vpc"
  }
}

resource "aws_internet_gateway" "cargowatch" {
  vpc_id = aws_vpc.cargowatch.id

  tags = {
    Name = "cargowatch-igw"
  }
}

resource "aws_subnet" "cargowatch_public_a" {
  vpc_id                  = aws_vpc.cargowatch.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "cargowatch-public-a"
  }
}

resource "aws_subnet" "cargowatch_public_b" {
  vpc_id                  = aws_vpc.cargowatch.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "cargowatch-public-b"
  }
}

resource "aws_route_table" "cargowatch_public" {
  vpc_id = aws_vpc.cargowatch.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cargowatch.id
  }

  tags = {
    Name = "cargowatch-public-rt"
  }
}

resource "aws_route_table_association" "cargowatch_public_a" {
  subnet_id      = aws_subnet.cargowatch_public_a.id
  route_table_id = aws_route_table.cargowatch_public.id
}

resource "aws_route_table_association" "cargowatch_public_b" {
  subnet_id      = aws_subnet.cargowatch_public_b.id
  route_table_id = aws_route_table.cargowatch_public.id
}

# Security group for private AWS service endpoints
resource "aws_security_group" "cargowatch_endpoints" {
  name        = "cargowatch-endpoints-security-group"
  description = "Allow HTTPS from CargoWatch tasks to private AWS endpoints"
  vpc_id      = aws_vpc.cargowatch.id

  ingress {
    description     = "HTTPS from CargoWatch tasks"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.cargowatch.id]
  }

  egress = []

  tags = {
    Name = "CargoWatch VPC Endpoints Security Group"
  }
}

# Private ECR API endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.cargowatch.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.cargowatch_public_a.id]
  security_group_ids  = [aws_security_group.cargowatch_endpoints.id]

  tags = {
    Name = "cargowatch-ecr-api-endpoint"
  }
}

# Private ECR Docker registry endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.cargowatch.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.cargowatch_public_a.id]
  security_group_ids  = [aws_security_group.cargowatch_endpoints.id]

  tags = {
    Name = "cargowatch-ecr-dkr-endpoint"
  }
}

# Private CloudWatch Logs endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.cargowatch.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.cargowatch_public_a.id]
  security_group_ids  = [aws_security_group.cargowatch_endpoints.id]

  tags = {
    Name = "cargowatch-logs-endpoint"
  }
}

# S3 gateway endpoint for ECR image layers
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.cargowatch.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.cargowatch_public.id]

  tags = {
    Name = "cargowatch-s3-endpoint"
  }
}

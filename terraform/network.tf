
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


resource "aws_security_group" "cargowatch" {
  name        = "cargowatch-security-group"
  description = "Restrict CargoWatch access to the approved IP"
  vpc_id      = aws_vpc.cargowatch.id

  ingress {
    description = "Allow CargoWatch access from approved IP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CargoWatch Security Group"
  }
}

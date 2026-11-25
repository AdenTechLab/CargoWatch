
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

  tags = {
    Name = "CargoWatch Security Group"
  }
}

resource "aws_security_group_rule" "cargowatch_egress_https" {
  type              = "egress"
  description       = "Allow HTTPS outbound traffic"
  security_group_id = aws_security_group.cargowatch.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

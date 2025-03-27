resource "aws_security_group" "openvpn_sg" {
  name        = "openvpn-sg-${var.stage}"
  description = "Allow OpenVPN and SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "OpenVPN (UDP)"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_instance" "openvpn" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]
  associate_public_ip_address = true
  key_name               = var.key_name

  user_data = file("${path.module}/install_openvpn.sh")

  tags = merge({
    Name = "openvpn-${var.stage}"
  }, var.tags)
}

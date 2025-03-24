resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg-${var.stage}-${var.servicename}"
  vpc_id = var.vpc_id

  ingress {
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

resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = element(var.bastion_subnet_ids, 0)
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name

user_data = base64encode(templatefile("${path.module}/scripts/bastion_user_data.sh.tpl", {
  region        = var.region,
  cluster_name  = var.cluster_name
}))

  tags = merge({
    Name = "bastion-${var.stage}-${var.servicename}"
  }, var.tags)  
}

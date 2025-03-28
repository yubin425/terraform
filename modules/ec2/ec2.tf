resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.associate_public_ip_address

  tags = merge(tomap({
         Name =  "aws-${var.name}-${var.stage}-${var.servicename}"}),
        var.tags)
}

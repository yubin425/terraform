resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-${var.stage}-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-${var.stage}-sg"
  description = "Allow RDS access from backend (EKS)"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow backend access on DB port"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups  = [var.backend_sg_id]  # EKS 백엔드에서 접근 허용하는 SG ID
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier              = var.name
  db_name                = "wordpress"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  port                    = var.db_port
  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false
  storage_encrypted       = false
  apply_immediately       = true
  deletion_protection     = false

   tags = merge(
    tomap({
      Name = "aws-rds-${var.stage}-${var.servicename}-prv-rds"
    }),
    var.tags
  )

}

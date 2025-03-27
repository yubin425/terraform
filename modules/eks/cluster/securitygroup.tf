# EKS cluster security group
resource "aws_security_group_rule" "main_allow_worker" {
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.sg_eks_node_id
  description              = "Allow all traffic from worker node security group"
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg-${var.stage}-${var.servicename}"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
    security_groups = [var.sg_eks_node_id]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
   security_groups = [var.sg_eks_node_id] 
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "eks-cluster-sg-${var.stage}-${var.servicename}"
  }, var.tags)
  depends_on =[var.sg_eks_node]
}
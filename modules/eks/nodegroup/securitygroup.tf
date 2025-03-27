resource "aws_security_group" "sg_eks_node" {
  name   = "aws-sg-${var.stage}-${var.servicename}-eks-node"
  vpc_id = var.vpc_id

  # 클러스터와의 통신을 위한 ingress 규칙
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
  }
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "TCP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = var.sg_eks_cluster_ingress_list
  }
  # 노드 내부 통신을 위한 self 규칙
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "TCP"
    self      = true
  }

  ingress {
  from_port   = 10250
  to_port     = 10250
  protocol    = "TCP"
  cidr_blocks = var.sg_eks_cluster_ingress_list  # 또는 클러스터 내부 IP 범위
}

  # 모든 트래픽 허용 egress 규칙 (필요에 따라 조정)
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

  tags = merge(
    {
      Name = "aws-sg-${var.stage}-${var.servicename}-eks-node",
      "kubernetes.io/cluster/aws-eks-cluster-${var.stage}-${var.servicename}" = "owned"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ingress]  # 클러스터 변경시 불필요한 재생성을 막기 위해
  }
}

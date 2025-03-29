resource "aws_iam_role" "eks_cluster_role" {
  name = "aws-eks-cluster-role-${var.stage}-${var.servicename}"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "this" {
  name     = "eks-cluster-${var.stage}"
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.eks_subnet_ids
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = merge({
    Name = "eks-cluster-${var.stage}"
  }, var.tags)

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# resource "aws_security_group" "eks_cluster_sg" {
#   name        = "eks-cluster-sg-${var.stage}-${var.servicename}"
#   description = "Security group for EKS cluster"
#   vpc_id      = var.vpc_id


#   tags = merge({
#     Name = "eks-cluster-sg-${var.stage}-${var.servicename}"
#   }, var.tags)
# }

resource "aws_security_group_rule" "eks_api_from_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = var.bastion_sg_id
  description              = "Allow Bastion to access EKS API"
}


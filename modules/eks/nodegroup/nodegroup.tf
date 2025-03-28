

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = "nodegroup-${var.stage}-${var.servicename}"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = var.nodegroup_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # 런치 템플릿 사용 설정
  launch_template {
    id      = aws_launch_template.workers_launch_template.id
    version = "$Latest"
  }

  instance_types = [var.instance_type]
  ami_type       = "AL2_x86_64"

  tags = merge({
    Name = "eks-nodegroup-${var.stage}-${var.servicename}"
  }, var.tags)

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]
}

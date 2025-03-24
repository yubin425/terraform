resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
  depends_on   = [var.cluster_depends_on]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
  depends_on   = [var.cluster_depends_on, var.nodegroup_depends_on]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"
  depends_on   = [var.cluster_depends_on]
}

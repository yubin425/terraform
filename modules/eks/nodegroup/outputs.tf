#nodegroup output
output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

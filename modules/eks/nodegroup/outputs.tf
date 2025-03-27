#nodegroup output
output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}
output "eks_node_sg_id" {
  description = "EKS Node Security Group ID"
  value       = aws_security_group.sg_eks_node.id
}
output "eks_node_sg" {
  description = "EKS Node Security Group ID"
value       = aws_security_group.sg_eks_node
}
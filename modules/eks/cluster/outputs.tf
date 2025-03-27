output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_ca_data" {
  description = "EKS 클러스터 인증서 데이터 (base64)"
  value       = aws_eks_cluster.this.certificate_authority.0.data
}

output "cluster-sg" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
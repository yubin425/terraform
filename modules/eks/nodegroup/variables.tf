variable "stage" {}
variable "servicename" {}
variable "cluster_name" {}
variable "nodegroup_subnet_ids" {
  type = list(string)
}
variable "instance_type" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "tags" {
  type = map(string)
}
variable "vpc_id" {
}
variable "sg_eks_cluster_ingress_list"{
}
variable "cluster_id" {
  description = "EKS 클러스터 ID"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS 클러스터 엔드포인트"
  type        = string
}

variable "cluster_ca_data" {
  description = "EKS 클러스터 인증서 데이터 (base64)"
  type        = string
}
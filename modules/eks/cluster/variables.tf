variable "stage" {}
variable "servicename" {}
variable "vpc_id" {}
variable "bastion_sg_id" {}
variable "eks_subnet_ids" {
  type = list(string)
}
variable "cluster_version" {
  default = "1.29"
}
variable "tags" {
  type = map(string)
}
variable "sg_eks_cluster_ingress_list" {
  type = list(string)
}
variable "sg_eks_node_id"{

}
variable "sg_eks_node"{

}
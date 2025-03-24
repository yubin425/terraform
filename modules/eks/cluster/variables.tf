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

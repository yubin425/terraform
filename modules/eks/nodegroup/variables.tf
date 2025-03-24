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
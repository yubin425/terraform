variable "stage" {}
variable "servicename" {}
variable "ami" {}
variable "instance_type" {}
variable "bastion_subnet_ids" { #적용 될 서브넷
  type = list(string)
}
variable "vpc_id" {}
variable "key_name" {}
variable "tags" {
  type = map(string)
}
variable "region" {}

variable "cluster_name" {}  
variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

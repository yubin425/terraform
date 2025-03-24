variable "stage" {}
variable "servicename" {}
variable "ami" {}
variable "instance_type" {}

variable "eks_subnet_ids" { #적용 될 서브넷
  type = list(string)
}
variable "nodegroup_subnet_ids" { #적용 될 서브넷
  type = list(string)
}
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


#bastion
variable "cluster_version" {
  default = "1.29"
}
variable "bastion_sg_id" {
  description = "Security group ID for bastion"
  type        = string
}

#nodegroup
variable "desired_size" {
  default = 2
}
variable "max_size" {
  default = 3
}
variable "min_size" {
  default = 1
}

variable "instance_type" {
  default = "t3.medium"
}


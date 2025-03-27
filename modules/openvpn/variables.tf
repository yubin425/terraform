variable "stage" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "allowed_ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "tags" {
  type = map(string)
  default = {}
}

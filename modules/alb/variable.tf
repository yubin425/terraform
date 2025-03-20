variable "region" {
  type    = string
  default = "us-east-1"
}
variable "stage" {
  type    = string
  default = "stage"
}
variable "servicename" {
  type    = string
  default = "terrafrom_nilla0425"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "nilla0425_VPC"
  }
}

variable "az" {
  type    = list(any)
}

variable "internal" {
    type  = bool
    default = false
}

variable "public" {
    type  = bool
    default = false
}

variable "subnet_ids" {
    type  = list
    default = []
}

# variable "aws_s3_lb_logs_name" {
#     type  = string
# }
variable "idle_timeout" {
    type  = string
    default = "60"
}
variable "certificate_arn" {
    type  = string
}
variable "port" {
    type  = string
    default = "80"
}
variable "vpc_id" {
    type  = string
}
variable "domain" {
    type  = string
    default = ""
}
variable "hostzone_id" {
    type  = string
    default = ""
}
variable "hc_path" {
    type  = string
    default = "/"
}
variable "hc_healthy_threshold" {
    type  = number
    default = 5
}
variable "hc_unhealthy_threshold" {
    type  = number
    default = 2
}
variable "sg_allow_comm_list" {
    type = list
}
variable "target_type" {
    type = string
    default = "instance"
}

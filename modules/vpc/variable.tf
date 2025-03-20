# variables.tf
#Comm TAG
variable "tags" {
  type = map(string)
}
variable "stage" {
  type = string
}
variable "servicename" {
  type = string
}

#VPC
variable "az" {
  type = list(any)
}
variable "vpc_main_cidr"{
 description= "VPC main CIDR block"
}

#vpc subnet cidr
variable "subnet_public_az1" {
  type = string
}
variable "subnet_public_az2" {
  type = string
}

variable "subnet_fe_az1" {
  type = string
}
variable "subnet_fe_az2" {
  type = string
}

variable "subnet_be_az1" {
  type = string
}

variable "subnet_be_az2" {
  type = string
}

variable "subnet_db_az1" {
  type = string
}

variable "subnet_db_az2" {
  type = string
}

# ###SecurityGroup###
# variable "sg_allow_comm_list" {
#   type = list(any)
# }

# ##TGW##
# variable "create_tgw" {
#   type = bool
#   default = false
# }
# variable "shared_tgw" {
#   type = map
#   default = null
# }

# #flow_logs
# variable "cloudwatch_log_retention_in_days" {
#   type = string
#   default = "14"
# }
# variable "versioning_enabled" {
#   type = string
#   default = "true"
# }
# variable "lifecycle_rule_enabled" {
#   type = string
#   default = "true"
# }
# variable "STANDARD_IA_Transition_days" {
#   type = string
#   default = "30" #1M
# }
# variable "GLACIER_Transition_days" {
#   type = string
#   default = "180" #6M
# }
# variable "expiration_days" {
#   type = string
#   default = "365"#1Y
# }
# variable "kms_arn" {
#   type = string
# }
# variable "region" {
#   type = string
# }
# variable "isdev" {
#   type = bool
#   default = false
# }


variable "server_port" {
  description = "Webserver’s HTTP port"
  type        = number
  default     = 80
}

variable "my_ip" {
  description = "My public IP"
  type        = string
  default     = "0.0.0.0/0"
}


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
  default = "terrafrom-0425"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "nilla0425-VPC"
  }
}
variable "az" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1c"]
}

#VPC
variable "vpc_main_cidr" {
  type    = string
  default = "20.0.0.0/16"
}
variable "subnet_public_az1" {
  type    = string
  default = "20.0.0.0/24"
}
variable "subnet_public_az2" {
  type    = string
  default = "20.0.10.0/24"
}

variable "subnet_fe_az1" {
  type    = string
  default = "20.0.1.0/24"
}
variable "subnet_fe_az2" {
  type    = string
  default = "20.0.11.0/24"
}

variable "subnet_be_az1" {
  type    = string
  default = "20.0.2.0/24"
}

variable "subnet_be_az2" {
  type    = string
  default = "20.0.12.0/24"
}

variable "subnet_db_az1" {
  type    = string
  default = "20.0.3.0/24"
}

variable "subnet_db_az2" {
  type    = string
  default = "20.0.13.0/24"
}


# variable "create_tgw" {
#   type = bool
#   default = false
# }
# variable "ext_vpc_route" {
#   type = any
# }
# variable "security_attachments" {
#   type = any
# }
# variable "security_attachments_propagation" {
#   type = any
# }
# variable "tgw_sharing_accounts" {
#   type = map
# }


##Instance
variable "ami" {
  type    = string
  default = "ami-04c596dcf23eb98d8"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "instance_ebs_size" {
  type    = number
  default = 20
}
variable "instance_ebs_volume" {
  type    = string
  default = "gp3"
}

# variable "instance_user_data" {
#   type = string
# }
# variable "redis_endpoints" {
#   type = list
# }

##RDS
variable "rds_dbname" {
  type    = string
  default = "jung9546"
}
variable "rds_instance_count" {
  type    = string
  default = "2"
}
variable "sg_allow_ingress_list_aurora" {
  type    = list(any)
  default = ["10.2.92.64/26", "10.2.92.128/26", "10.2.92.18/32"]
}
variable "associate_public_ip_address" {
  type    = bool
  default = true
}

##KMS
variable "rds_kms_arn" {
  type    = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/1dbf43f7-1847-434c-bc3c-1beb1b86e480"
}
variable "ebs_kms_key_id" {
  type    = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/43b0228d-0a06-465c-b25c-7480b07b5276"
}

#server_port
variable "server_port" {
  description = "Webserver’s HTTP port"
  type        = number
  default     = 80
}

variable "my_ip" {
  description = "My public IP"
  type        = string
  default = "0.0.0.0/0"
}

#alb
variable "alb_security_group_name" {
  description = "the name of the ALB's security group"
  type        = string
  default = "value"
}

variable "alb_name" {
  description = "The name of ALB"
  type        = string
  default = "value"
}

# variable "aws_s3_lb_logs_name" {
#     type  = string
# }
variable "certificate_arn" {
    type  = string
    default = "arn:aws:acm:us-east-1:509399632105:certificate/2d0c695a-bbf8-4377-a80f-4e6937670f80"
}
variable "vpc_id" {
    type  = string
    default = "module.vpc.vpc_id "
}
# variable "instance_ids" {
#     type  = list
# }
variable "sg_allow_comm_list" {
    type = list
    default = ["0.0.0.0/0"]
}
variable "target_type" {
    type = string
    default = "instance"
}

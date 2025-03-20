variable "stage" {
  type        = string
  description = "Deployment stage (e.g. dev, staging, prod)"
}

variable "servicename" {
  type        = string
  description = "Service name"
}

variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2"
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of EC2 instances"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of EC2 instances"
  default     = 3
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EC2 instances"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EC2 instances will be deployed"
}

variable "port" {
  type        = number
  description = "Port on which EC2 instances will listen"
  default     = 80
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID of ALB to allow incoming traffic"
}

variable "target_group_arn" {
  type        = string
  description = "Target Group ARN for ALB"
}

variable "user_data" {
  type        = string
  description = "User data script to initialize EC2 instances"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

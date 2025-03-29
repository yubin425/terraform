variable "stage" {
  type        = string
}

variable "servicename" {
  type        = string
}

variable "ami" {
  description = "The AMI ID for the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}

variable "vpc_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}


variable "key_name" {
  description = "The key pair name to use for SSH access."
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the instance."
  type        = map(string)
}

variable "name" {
  description = "Name tag for the instance."
  type        = string
}

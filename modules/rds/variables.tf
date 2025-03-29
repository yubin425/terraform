variable "name" {
  description = "Identifier for the RDS instance"
  type        = string
}
variable "stage" {
  type        = string
}
variable "servicename" {
  type        = string
}
variable "vpc_id" {
  description = "VPC ID where the RDS instance will be created"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "backend_sg_id" {
  description = "Security Group ID of the backend (EKS) allowed to access RDS"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "tags" {
  description = "Tags to apply to the RDS resources"
  type        = map(string)
  default     = {}
}

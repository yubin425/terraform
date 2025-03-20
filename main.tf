provider "aws" {
 region = "us-east-1"
 default_tags{
  tags={
   Name= "nilla-terraform"
}
}
}

# terraform {
#   required_version = ">= 1.0.0, < 2.0.0"
#   backend "s3" {
#         bucket = "nilla-terraform-s3"
#         key = "vpc/terraform.tfstate"
#         region = "us-east-1"
#         encrypt = true
#         dynamodb_table = "nilla-terraform-lock"
    
#   }
# }

module "vpc" {
  source              = "./modules/vpc"

  vpc_main_cidr = var.vpc_main_cidr
  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  subnet_public_az1 = var.subnet_public_az1
  subnet_public_az2 = var.subnet_public_az2
  subnet_fe_az1 = var.subnet_fe_az1
  subnet_fe_az2 = var.subnet_fe_az2
  subnet_be_az1 = var.subnet_be_az1
  subnet_be_az2 = var.subnet_be_az2
  subnet_db_az1  = var.subnet_db_az1
  subnet_db_az2  = var.subnet_db_az2

  # region     = var.region
  # kms_arn = var.s3_kms_key_id
  az           = var.az
}

module "ec2" {
  source          = "./modules/ec2"
  stage           = var.stage
  servicename     = var.servicename
  ami             = "ami-0ea4029a71f24b319" 
  instance_type   = "t3.micro"
  subnet_ids      = module.vpc.public_subnet_ids  # 퍼블릭 서브넷 사용
  vpc_id          = module.vpc.vpc_id
  alb_sg_id       = module.alb.alb_sg_id  # ALB 보안 그룹 ID 전달
  target_group_arn = module.alb.target_group_arn  # ALB Target Group ARN 전달
  tags            = var.tags
}


module "alb" {
  source      = "./modules/alb"  # ALB 모듈의 경로 (변경 가능)
  
  stage       = var.stage
  servicename = var.servicename
  region      = var.region
  az           = var.az

  vpc_id      = module.vpc.vpc_id # VPC ID
  subnet_ids  = module.vpc.public_subnet_ids  # 서브넷 리스트
  #aws_s3_lb_logs_name = var.aws_s3_lb_logs_name
  certificate_arn = var.certificate_arn
  sg_allow_comm_list = var.sg_allow_comm_list
  target_type = var.target_type

  tags       = var.tags
}


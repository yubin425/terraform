provider "aws" {
 region = "us-east-1"
 default_tags{
  tags={
   Name= "nilla-terraform"
}
}
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  backend "s3" {
        bucket = "nilla-terraform-state-s3"
        key = "vpc/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "nilla-terraform-lock"
    
  }
}

module "vpc" {
  source              = "../modules/vpc"
  vpc_main_cidr = var.vpc_main_cidr
  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags

  subnet_public_az1 = var.subnet_public_az1
  subnet_public_az2 = var.subnet_public_az2
  //subnet_fe_az1 = var.subnet_fe_az1
  //subnet_fe_az2 = var.subnet_fe_az2
  subnet_be_az1 = var.subnet_be_az1
  subnet_be_az2 = var.subnet_be_az2
  subnet_db_az1  = var.subnet_db_az1
  subnet_db_az2  = var.subnet_db_az2

  # region     = var.region
  # kms_arn = var.s3_kms_key_id
  az           = var.az
}

### ec2
# module "ec2" {
#   source          = "../modules/ec2"
#   stage           = var.stage
#   servicename     = var.servicename
#   ami             = "ami-0ea4029a71f24b319" 
#   instance_type   = "t3.micro"
#   subnet_ids      = module.vpc.public_subnet_ids  # 퍼블릭 서브넷 사용
#   vpc_id          = module.vpc.vpc_id
#   alb_sg_id       = module.alb.alb_sg_id  # ALB 보안 그룹 ID 전달
#   target_group_arn = module.alb.target_group_arn  # ALB Target Group ARN 전달
#   tags            = var.tags
# }


# #외부 alb
# module "alb" {
#   source      = "../modules/alb"  # ALB 모듈의 경로 (변경 가능)
  
#   stage       = var.stage
#   servicename = var.servicename
#   region      = var.region
#   az           = var.az

#   vpc_id      = module.vpc.vpc_id # VPC ID
#   subnet_ids  = module.vpc.public_subnet_ids  # 서브넷 리스트
#   #aws_s3_lb_logs_name = var.aws_s3_lb_logs_name
#   certificate_arn = var.certificate_arn
#   sg_allow_comm_list = var.sg_allow_comm_list
#   target_type = var.target_type

#   tags       = var.tags
# }

#eks
module "eks_cluster" {
  source        = "../modules/eks/cluster"
  stage         = var.stage
  servicename   = var.servicename
  cluster_version = "1.29"
  tags          = var.tags
  eks_subnet_ids    = concat(
                    module.vpc.public_subnet_ids,
                    module.vpc.be_subnet_ids
                  )
  bastion_sg_id = module.eks_bastion.bastion_sg_id
  vpc_id = module.vpc.vpc_id
  sg_eks_cluster_ingress_list = ["0.0.0.0/0"]
  sg_eks_node_id = module.eks_nodegroup.eks_node_sg_id
  sg_eks_node = module.eks_nodegroup.eks_node_sg
  
}

#eks-nodegroup
module "eks_nodegroup" {
  source        = "../modules/eks/nodegroup"
  cluster_name  = module.eks_cluster.cluster_name
  stage         = var.stage
  servicename   = var.servicename
  nodegroup_subnet_ids    = module.vpc.be_subnet_ids
  instance_type = "t3.medium"
  desired_size  = 2
  max_size      = 3
  min_size      = 1
  tags          = var.tags
  vpc_id = module.vpc.vpc_id
  sg_eks_cluster_ingress_list = ["0.0.0.0/0"]

  cluster_id         = module.eks_cluster.cluster_name
  cluster_endpoint   = module.eks_cluster.cluster_endpoint
  cluster_ca_data    = module.eks_cluster.cluster_ca_data
}

#bastion
module "eks_bastion" {
  source        = "../modules/eks/bastion"
  stage         = var.stage
  servicename   = var.servicename
  region = var.region
  cluster_name = module.eks_cluster.cluster_name
  ami           = "ami-08b5b3a93ed654d19" # Amazon Linux 2 (us-east-1)
  instance_type = "t3.micro"
  bastion_subnet_ids    = module.vpc.public_subnet_ids
  vpc_id        = module.vpc.vpc_id
  key_name      = var.key_name
  tags          = var.tags
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]
}

#oidc
module "eks_oidc" {
  source       = "../modules/eks/oidc"
  stage         = var.stage
  tags         = var.tags

  oidc_issuer_url   = module.eks_cluster.oidc_issuer_url
  cluster_name = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster]
}

#addons
module "addons" {
  source                = "../modules/eks/addons"
  cluster_name          = module.eks_cluster.cluster_name
  cluster_depends_on    = module.eks_cluster
  nodegroup_depends_on  = module.eks_nodegroup
}


# data "aws_eks_cluster" "cluster" {
#   name = module.eks_cluster.cluster_id
#   depends_on = [module.eks_cluster]
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks_cluster.cluster_id
#   depends_on = [module.eks_cluster]
# }


#alb-controller

provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_data)
  //token                  = data.aws_eks_cluster_auth.cluster.token
          exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks_cluster.cluster_name
      ]
        }

  #config_path = "${path.module}/.kubeconfig"
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_data)
    //token                  = data.aws_eks_cluster_auth.cluster.token
        exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks_cluster.cluster_name
      ]
        }
  }
}

module "alb_controller" {
  source = "../modules/eks/alb-controller"

  cluster_name = module.eks_cluster.cluster_name
  region       = var.region
  vpc_id       = module.vpc.vpc_id

  alb_sa_role_arn = module.eks_oidc.alb_sa_role_arn
  alb_policy_attachment_depends_on = [
    module.eks_oidc.alb_policy_attachment
  ]
    providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }
    depends_on = [module.eks_cluster]
}

module "argocd" {
  source = "../modules/argocd"
  acm_certificate_arn = var.certificate_arn
  argocd_domain = var.argocd_domain
  git_be_url = "https://github.com/yubin425/terraform-be.git"
    providers = {
    kubernetes = kubernetes.eks 
    helm       = helm.eks
  }
   depends_on = [module.eks_cluster, module.alb_controller]
}

module "s3" {
  source      = "../modules/s3"
  bucket_name = "test.nilla.o-r.kr"
  tags = var.tags
}

module "cloudfront" {
  source                      = "../modules/cloudfront"
  bucket_name                 = module.s3.bucket_name
  bucket_arn                  = module.s3.bucket_arn
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  domain_name                 = "test.nilla.o-r.kr"
  acm_certificate_arn        = var.certificate_arn
}

# module "openvpn" {
#   source     = "../modules/openvpn"
#   stage      = var.stage
#   ami        = "ami-06e5a963b2dadea6f" # openvpn server ami
#   instance_type = "t3.micro"
#   key_name   = "my-key"
#   vpc_id     = module.vpc.vpc_id
#   subnet_id  = module.vpc.public_subnet_ids[0]
#   allowed_ssh_cidr_blocks = ["0.0.0.0/0"]
#   tags       = var.tags
# }

#rds
resource "aws_default_security_group" "eks_default" {
  vpc_id = module.vpc.vpc_id
}


# data "aws_security_groups" "eks_node_sg" {
#   filter {
#     name   = "tag:aws:eks:cluster-name"
#     values = ["eks-cluster-dev"]
#   }
#   depends_on = [module.eks_cluster, module.eks_nodegroup]

# }

module "rds" {
  source = "../modules/rds"

  name           = var.rds_name
  stage = var.stage
  servicename = var.servicename
  vpc_id         = module.vpc.vpc_id
  db_subnet_ids  = module.vpc.db_subnet_ids   # VPC 모듈에서 DB 전용 서브넷 ID 리스트
  backend_sg_id  = module.eks_nodegroup.eks_node_sg_id  #data.aws_security_groups.eks_node_sg.id #노드그룹 sg 설정후 변경할 것
  db_username    = var.db_username
  db_password    = var.db_password
  tags           = var.tags
  
}
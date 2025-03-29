#vpc 생성
resource "aws_vpc" "nilla_terraform_vpc" {
 cidr_block = var.vpc_main_cidr
 instance_tenancy = "default"
 enable_dns_hostnames= true

tags = merge(tomap({
        Name = upper("x-${var.stage}-${var.servicename}")}), 
        var.tags)

lifecycle {
    ignore_changes = [tags, tags_all]
  }
}

# resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr"{
#         vpc_id = aws_vpc.nilla_terraform_vpc.id
#         cidr_block = "10.1.0.0/23"
# }

#subnet
#퍼블릭 서브넷
resource "aws_subnet" "pub_sub_1" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_public_az1
  availability_zone       = element(var.az, 0)
  map_public_ip_on_launch = true

  tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-pub-az1"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/elb" = 1}), var.tags)
  depends_on = [ #vpc 생성 후 서브넷이 생성되도록 보장
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle { #태그 삭제 방지
    ignore_changes = [tags, tags_all]
  }
}
resource "aws_subnet" "pub_sub_2" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_public_az2
  availability_zone       = element(var.az, 1)
  map_public_ip_on_launch = true

  tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-pub-az2"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/elb" = 1}), var.tags)
  depends_on = [ #vpc 생성 후 서브넷이 생성되도록 보장
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle { #태그 삭제 방지
    ignore_changes = [tags, tags_all]
  }
}


#프라이빗 서브넷 - nat 허용 (FE)
# resource "aws_subnet" "prv_sub_fe_1" {
#   vpc_id            = aws_vpc.nilla_terraform_vpc.id
#   cidr_block        = var.subnet_fe_az1
#   availability_zone       = element(var.az, 0)
#   map_public_ip_on_launch = false
#     tags = merge(tomap({
#          Name = upper("aws-subnet-${var.stage}-${var.servicename}-fe-az1"),
#          "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
#          "kubernetes.io/role/internal-elb"     = 1}),
#         var.tags)
#   depends_on = [
#     aws_vpc.nilla_terraform_vpc
#   ]
#   lifecycle {
#     ignore_changes = [tags, tags_all]
#   }
# }
# resource "aws_subnet" "prv_sub_fe_2" {
#   vpc_id            = aws_vpc.nilla_terraform_vpc.id
#   cidr_block        = var.subnet_fe_az2
#   availability_zone       = element(var.az, 1)
#   map_public_ip_on_launch = false
#     tags = merge(tomap({
#          Name = upper("aws-subnet-${var.stage}-${var.servicename}-fe-az2"),
#          "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
#          "kubernetes.io/role/internal-elb"     = 1}),
#         var.tags)
#   depends_on = [
#     aws_vpc.nilla_terraform_vpc
#   ]
#   lifecycle {
#     ignore_changes = [tags, tags_all]
#   }
# }

#프라이빗 서브넷 - BE 
resource "aws_subnet" "prv_sub_be_1" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_be_az1
  availability_zone       = element(var.az, 0)
  map_public_ip_on_launch = false
    tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-be-az1"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/internal-elb"     = 1}),
        var.tags)
  depends_on = [
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}
resource "aws_subnet" "prv_sub_be_2" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_be_az2
  availability_zone       = element(var.az, 1)
  map_public_ip_on_launch = false
    tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-be-az2"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/internal-elb"     = 1}),
        var.tags)
  depends_on = [
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}

#프라이빗 서브넷 - RDS
resource "aws_subnet" "prv_sub_db_1" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_db_az1
  availability_zone       = element(var.az, 0)
  map_public_ip_on_launch = false
    tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-db-az1"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/internal-elb"     = 1}),
        var.tags)
  depends_on = [
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}
resource "aws_subnet" "prv_sub_db_2" {
  vpc_id            = aws_vpc.nilla_terraform_vpc.id
  cidr_block        = var.subnet_db_az2
  availability_zone       = element(var.az, 1)
  map_public_ip_on_launch = false
    tags = merge(tomap({
         Name = upper("aws-subnet-${var.stage}-${var.servicename}-db-az2"),
         "kubernetes.io/cluster/eks-cluster-${var.stage}" = "shared",
         "kubernetes.io/role/internal-elb"     = 1}),
        var.tags)
  depends_on = [
    aws_vpc.nilla_terraform_vpc
  ]
  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}


#인터넷 게이트웨이 생성
resource "aws_internet_gateway" "vpc-igw" {
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        tags = merge(tomap({
        Name = "aws-igw-${var.stage}-${var.servicename}"}), 
        var.tags)
}

#nat에 eip 부여
resource "aws_eip" "nat_eip1" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.vpc-igw]
  tags = merge(tomap({
        Name = "aws-eip1-${var.stage}-${var.servicename}-nat"}), 
        var.tags)
}
resource "aws_eip" "nat_eip2" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.vpc-igw]
  tags = merge(tomap({
        Name = "aws-eip2-${var.stage}-${var.servicename}-nat"}), 
        var.tags)
}

#nat gateway 생성(퍼블릭)
resource "aws_nat_gateway" "nat_gw_1"{
        allocation_id = aws_eip.nat_eip1.id
        subnet_id = aws_subnet.pub_sub_1.id
        depends_on = [aws_internet_gateway.vpc-igw,aws_eip.nat_eip1]
        tags = merge(tomap({
         Name = "aws-nat1-${var.stage}-${var.servicename}"}), 
        var.tags)           
}
resource "aws_nat_gateway" "nat_gw_2"{
        allocation_id = aws_eip.nat_eip2.id
        subnet_id = aws_subnet.pub_sub_2.id
        depends_on = [aws_internet_gateway.vpc-igw,aws_eip.nat_eip2]
        tags = merge(tomap({
         Name = "aws-nat2-${var.stage}-${var.servicename}"}), 
        var.tags) 
}

#route table
#퍼블릭 서브넷 라우팅 테이블
resource "aws_route_table" "pub_rt"{
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        route{
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.vpc-igw.id
        }
        tags = merge(tomap({
                Name = "aws-rt-${var.stage}-${var.servicename}-pub"}), 
                var.tags)
}
resource "aws_route_table_association" "pub_rt1_asso"{
        subnet_id= aws_subnet.pub_sub_1.id
        route_table_id = aws_route_table.pub_rt.id
}
resource "aws_route_table_association" "pub_rt2_asso"{
        subnet_id= aws_subnet.pub_sub_2.id
        route_table_id = aws_route_table.pub_rt.id
}

# #프라이빗 서브넷(fe) 라우팅 테이블
# resource "aws_route_table" "prv_fe_rt1"{
#         vpc_id = aws_vpc.nilla_terraform_vpc.id
#         route{
#         cidr_block = "0.0.0.0/0"
#         nat_gateway_id = aws_nat_gateway.nat_gw_1.id
#         }
#         tags = merge(tomap({
#                 Name = "aws-rt1-${var.stage}-${var.servicename}-prv-fe"}), 
#                 var.tags)        
# }
# resource "aws_route_table" "prv_fe_rt2"{
#         vpc_id = aws_vpc.nilla_terraform_vpc.id
#         route{
#         cidr_block = "0.0.0.0/0"
#         nat_gateway_id = aws_nat_gateway.nat_gw_2.id
#         }
#         tags = merge(tomap({
#                 Name = "aws-rt2-${var.stage}-${var.servicename}-prv-fe"}), 
#                 var.tags)
# }
# resource "aws_route_table_association" "prv_fe_rt1_asso"{
#         subnet_id= aws_subnet.prv_sub_fe_1.id
#         route_table_id = aws_route_table.prv_fe_rt1.id
# }
# resource "aws_route_table_association" "prv_fe_rt2_asso"{
#         subnet_id= aws_subnet.prv_sub_fe_2.id
#         route_table_id = aws_route_table.prv_fe_rt2.id
# }

#프라이빗 서브넷(be) 라우팅 테이블 (nat 허용)
resource "aws_route_table" "prv_be_rt1"{
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        route {
        cidr_block = "0.0.0.0/0" #aws_vpc.nilla_terraform_vpc.cidr_block # VPC 내부 통신
        nat_gateway_id = aws_nat_gateway.nat_gw_1.id
        }
        tags = merge(tomap({
                Name = "aws-rt1-${var.stage}-${var.servicename}-prv-be"}), 
                var.tags)
}

resource "aws_route_table" "prv_be_rt2"{
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        route {
        cidr_block = "0.0.0.0/0" #aws_vpc.nilla_terraform_vpc.cidr_block # VPC 내부 통신
        nat_gateway_id = aws_nat_gateway.nat_gw_2.id
        }
        tags = merge(tomap({
                Name = "aws-rt2-${var.stage}-${var.servicename}-prv-be"}), 
                var.tags)
        
}
resource "aws_route_table_association" "prv_be_rt1_asso"{
        subnet_id= aws_subnet.prv_sub_be_1.id
        route_table_id = aws_route_table.prv_be_rt1.id
        depends_on = [aws_nat_gateway.nat_gw_1]
}
resource "aws_route_table_association" "prv_be_rt2_asso"{
        subnet_id= aws_subnet.prv_sub_be_2.id
        route_table_id = aws_route_table.prv_be_rt2.id
        depends_on = [aws_nat_gateway.nat_gw_2]
}


#프라이빗 서브넷(db) 라우팅 테이블
resource "aws_route_table" "prv_rds_rt1"{
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        # 내부 통신을 위한 라우팅 (VPC 자체 라우팅)
        route {
        cidr_block = aws_vpc.nilla_terraform_vpc.cidr_block # VPC 내부 통신
        gateway_id = "local"
        }
        tags = merge(tomap({
                Name = "aws-rt1-${var.stage}-${var.servicename}-prv-rds"}), 
                var.tags)
}
resource "aws_route_table" "prv_rds_rt2"{
        vpc_id = aws_vpc.nilla_terraform_vpc.id
        # 내부 통신을 위한 라우팅 (VPC 자체 라우팅)
        route {
        cidr_block = aws_vpc.nilla_terraform_vpc.cidr_block # VPC 내부 통신
        gateway_id = "local"
        }
        tags = merge(tomap({
                Name = "aws-rt2-${var.stage}-${var.servicename}-prv-rds"}), 
                var.tags)
}
resource "aws_route_table_association" "prv_rds_rt1_asso"{
        subnet_id= aws_subnet.prv_sub_db_1.id
        route_table_id = aws_route_table.prv_rds_rt1.id
}
resource "aws_route_table_association" "prv_rds_rt2_asso"{
        subnet_id= aws_subnet.prv_sub_db_2.id
        route_table_id = aws_route_table.prv_rds_rt2.id
}



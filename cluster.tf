# # cluster.tf
# resource "aws_security_group" "webserver_sg" {
#   name   = "webserver-sg-student0"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = var.server_port
#     to_port     = var.server_port
#     protocol    = "tcp"
#     cidr_blocks = [
#       aws_subnet.pub_sub_1.cidr_block,
#       aws_subnet.pub_sub_2.cidr_block
#     ]
#   }
#     # ✅ SSH 접근 허용 (22번 포트)
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # 모든 IP에서 SSH 접근 허용 (보안상 변경 권장)
#   }
# }

# #자동확장그룹 작성
# resource "aws_launch_template" "webserver_template" {
#   image_id      = "ami-0ea4029a71f24b319"
#   instance_type = "t3.micro"
#   vpc_security_group_ids = [aws_security_group.webserver_sg.id]

#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     # 시스템 패키지 업데이트 및 busybox 설치
#     yum update -y
#     yum install -y busybox

#     # 웹 서버 루트 디렉토리 생성
#     mkdir -p /var/www

#     # 기본 웹 페이지 생성
#     echo "Hello, World" > /var/www/index.html

#     # busybox 웹 서버 실행 (백그라운드 실행)
#     nohup busybox httpd -f -p 80 -h /var/www &

#     # 실행 확인 로그
#     echo "BusyBox HTTP server started on port 80"
#   EOF
#   )
# }



# resource "aws_autoscaling_group" "webserver_asg"{
#   vpc_zone_identifier = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
#   #자동확장 그룹에 대상 그룹지정
#   target_group_arns   = [aws_lb_target_group.target_asg.arn]
#   health_check_type   = "ELB"
#         min_size = 2
#         max_size = 3
#         launch_template {
#                 id = aws_launch_template.webserver_template.id
#                 version = "$Latest"
#         }
#         depends_on = [aws_vpc.my_vpc, aws_subnet.pub_sub_1, aws_subnet.pub_sub_2]
# }

# #alb작성
# resource "aws_security_group" "alb_sg" {
#   name   = var.alb_security_group_name
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     from_port   = var.server_port
#     to_port     = var.server_port
#     protocol    = "tcp"
#     cidr_blocks = [var.my_ip]
#   }
  
#    egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# #alb 리소스 생성
# resource "aws_lb" "webserver_alb"{
#         name = var.alb_name
#         load_balancer_type = "application"
#         subnets = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
#         security_groups =[aws_security_group.alb_sg.id] 
#   #dle_timeout = 300
# }

# #alb 대상 그룹 생성
# resource "aws_lb_target_group" "target_asg" {
#   name     = var.alb_name
#   port     = var.server_port
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id

#   health_check {
#     path                 = "/"
#     protocol             = "HTTP"
#     matcher              = "200"
#     interval             = 30 #interval 변경
#     timeout              = 5
#     healthy_threshold    = 2
#     unhealthy_threshold  = 2
#   }
# }

# #리스너 생성
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.webserver_alb.arn
#   port              = var.server_port
#   protocol          = "HTTP"

#   default_action {
#     type           = "forward"
#     target_group_arn = aws_lb_target_group.target_asg.arn
#   }
# }
# #리스너 규칙 지정
# resource "aws_lb_listener_rule" "webserver_asg_rule" {
#   listener_arn = aws_lb_listener.http.arn
#   priority     = 100

#   condition {
#     path_pattern {
#       values = ["*"]
#     }
#   }

#   action {
#     type           = "forward"
#     target_group_arn = aws_lb_target_group.target_asg.arn
#   }
# }
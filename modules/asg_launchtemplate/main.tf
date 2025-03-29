# Launch Template (EC2 인스턴스 설정 템플릿)
resource "aws_launch_template" "ec2_template" {
  name_prefix   = "lt-${var.stage}-${var.servicename}"
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # 시스템 패키지 업데이트 및 busybox 설치
    yum update -y
    yum install -y busybox

    # 웹 서버 루트 디렉토리 생성
    mkdir -p /var/www

    # 기본 웹 페이지 생성
    echo "Hello, World" > /var/www/index.html

    # busybox 웹 서버 실행 (백그라운드 실행)
    nohup busybox httpd -f -p 80 -h /var/www &

    # 실행 확인 로그
    echo "BusyBox HTTP server started on port 80"
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(tomap({
      Name = "ec2-${var.stage}-${var.servicename}"
    }), var.tags)
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                = "asg-${var.stage}-${var.servicename}"
  desired_capacity    = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]  # ALB Target Group과 연결

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2-${var.stage}-${var.servicename}"
    propagate_at_launch = true
  }
}

# Auto Scaling Policy (CPU 기반 스케일링)
resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "scale-out-${var.stage}-${var.servicename}"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
  metric_aggregation_type = "Average"
}

resource "aws_autoscaling_policy" "cpu_scale_in" {
  name                   = "scale-in-${var.stage}-${var.servicename}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
  metric_aggregation_type = "Average"
}

# ALB 보안 그룹
resource "aws_security_group" "sg-ec2" {
  name   = "aws-sg-${var.stage}-${var.servicename}-ec2"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "TCP"
    security_groups = [var.alb_sg_id]  # ALB에서만 접근 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({
    Name = "aws-sg-${var.stage}-${var.servicename}-ec2"
  }), var.tags)
}

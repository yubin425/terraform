output "sg_alb_to_tg_id" {
  value = aws_security_group.sg-alb-to-tg.id
}
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

# Target Group ARN 출력
output "target_group_arn" {
  value = aws_lb_target_group.target-group.arn
}
# ALB 보안 그룹 ID 출력 (EC2에서 사용)
output "alb_sg_id" {
  value = aws_security_group.sg-alb.id
}
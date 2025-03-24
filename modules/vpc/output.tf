output "vpc_id" {
  value = aws_vpc.nilla_terraform_vpc.id
}
output "public_subnet_ids" {
  value = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
}
output "be_subnet_ids" {
  value = [aws_subnet.prv_sub_be_1.id, aws_subnet.prv_sub_be_2.id]
}
# output "fe_subnet_ids" {
#   value = [aws_subnet.prv_sub_fe_1.id, aws_subnet.prv_sub_fe_2.id]
# }


# output "fe_subnet_cidrs" {
#   value = [aws_subnet.prv_sub_fe_1.cidr_block, aws_subnet.prv_sub_fe_2.cidr_block]
# }
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_dmz_id" {
  value = aws_subnet.dmz.id
}

output "subnet_app_id" {
  value = aws_subnet.app.id
}

output "subnet_bd_id" {
  value = aws_subnet.bd.id
}

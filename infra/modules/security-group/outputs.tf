output "app_security_group_id" {
  description = "ID do security group da aplicação"
  value       = aws_security_group.app.id
}

output "rds_security_group_id" {
  description = "ID do security group do RDS"
  value       = aws_security_group.rds.id
}

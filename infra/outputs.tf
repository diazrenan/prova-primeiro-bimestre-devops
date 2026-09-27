output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.vpc.private_subnet_ids
}

output "ec2_public_ip" {
  description = "IP público da instância EC2"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "DNS público da instância EC2"
  value       = module.ec2.public_dns
}

output "db_endpoint" {
  description = "Endpoint de conexão do banco de dados RDS"
  value       = module.rds.db_endpoint
}

output "app_sg_id" {
  description = "ID do security group da aplicação"
  value       = module.security_group.app_security_group_id
}

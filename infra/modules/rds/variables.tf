variable "project_name" {
  description = "Nome do projeto, usado como prefixo nos recursos"
  type        = string
}

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "reservas"
}

variable "db_username" {
  description = "Usuário do banco de dados"
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Lista de IDs de subnets para o subnet group do RDS"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do security group do RDS"
  type        = string
}

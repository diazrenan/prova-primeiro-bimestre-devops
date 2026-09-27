variable "project_name" {
  description = "Nome do projeto, usado como prefixo nos recursos"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "security_group_id" {
  description = "ID do security group associado à instância"
  type        = string
}

variable "key_name" {
  description = "Nome do key pair para acesso SSH"
  type        = string
}

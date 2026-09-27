variable "project_name" {
  description = "Nome do projeto, usado como prefixo nos recursos"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde os security groups serão criados"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "Lista de CIDRs com permissão de acesso SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

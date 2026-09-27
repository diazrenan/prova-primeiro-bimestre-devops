variable "aws_region" {
  description = "Região AWS onde os recursos de backend serão criados"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome do bucket S3 para armazenar o Terraform state"
  type        = string
  default     = "prova-devops-tfstate"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB para lock do Terraform state"
  type        = string
  default     = "prova-devops-tfstate-lock"
}

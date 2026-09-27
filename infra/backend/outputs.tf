output "s3_bucket_name" {
  description = "Nome do bucket S3 criado para o remote state"
  value       = aws_s3_bucket.tfstate.bucket
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 do remote state"
  value       = aws_s3_bucket.tfstate.arn
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB para lock do state"
  value       = aws_dynamodb_table.tfstate_lock.name
}

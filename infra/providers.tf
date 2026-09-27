terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "prova-devops-tfstate"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prova-devops-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

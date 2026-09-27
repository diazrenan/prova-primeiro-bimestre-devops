terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "prova-devops-tfstate-renan-6325033-v2"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prova-devops-tfstate-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}
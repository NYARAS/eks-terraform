terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.1" # Optional but recommended in production
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }
  }
  backend "s3" {}

}

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

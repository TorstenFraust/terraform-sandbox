terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }

  required_version = ">= 1.10.4"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox-aws-admin"
}


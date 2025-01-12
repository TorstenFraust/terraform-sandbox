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

resource "aws_iam_openid_connect_provider" "example" {
  url             = "https://example.com"
  client_id_list  = ["YOUR_CLIENT_ID"]
  thumbprint_list = ["YOUR_SERVER_CERTIFICATE_THUMBPRINT"]
}


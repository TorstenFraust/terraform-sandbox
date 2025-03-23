# Terraform AWS Sandbox

This repository contains Terraform configurations for setting up AWS resources, including VPC, Subnets, Security Groups, and Load Balancers.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.10.4 or higher
- [AWS CLI](https://aws.amazon.com/cli/)
- [dotenv](https://github.com/motdotla/dotenv) (optional, for loading environment variables from a `.env` file)

## Setup

### Environment Variables

To securely manage sensitive information like the Auth0 Client ID, you can use environment variables. Follow these steps:

1. **Create an `.env` file in the root of your repository:**

    ```plaintext
    # .env
    AUTH0_CLIENT_ID=your_actual_auth0_client_id
    ```

2. **Load the `.env` file in your shell session:**

    You can use a tool like `dotenv` to load the environment variables from the `.env` file into your shell session. Install `dotenv` if you haven't already:

    ```sh
    brew install dotenv
    ```

    Then, load the [.env](http://_vscodecontentref_/1) file:

    ```sh
    dotenv -f .env
    ```

### Terraform Configuration

The [main.tf](http://_vscodecontentref_/2) file includes the necessary provider configurations:

```terraform
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
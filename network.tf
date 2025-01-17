#  all configuration for network resources will be done here like VPC, Subnet, Security Group etc.

module "simple_webserver_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "simple_webserver_vpc"
  cidr = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    owner = "torsten"
  }
}
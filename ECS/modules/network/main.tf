module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.name
  cidr = "10.99.0.0/18"

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = ["10.99.0.0/24", "10.99.1.0/24"]
  public_subnets   = ["10.99.2.0/24", "10.99.3.0/24"]
  database_subnets = ["10.99.4.0/24", "10.99.5.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

terraform {
  backend "s3" {
    bucket = "ln-terraform-state-bucket"
    key    = "terraform-ecs/key"
    region = "us-east-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

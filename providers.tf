
# Terraform Providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  /*
  backend "s3" {
    bucket         = "autoscaling-tfstate"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/terraform-state-bucket-key"
    dynamodb_table = "terraform-state"
  }
  */
}
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tgi-terraform-bucket"
    key    = "s3-bucket-listing-api"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = local.region
} 

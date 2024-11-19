terraform {
  backend "s3" {
    bucket = "thevault-db-dmps"
    key    = "service.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
  region = local.region
} 

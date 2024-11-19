terraform {
  backend "s3" {
    bucket = "thevault-db-dmps"
    key    = "alb.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "aws" {
  region = local.region
}

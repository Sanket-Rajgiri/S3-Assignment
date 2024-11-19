data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "thevault-db-dmps"
    key    = "vpc.tfstate"
    region = "us-west-2"
  }
  workspace = local.environment
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "thevault-db-dmps"
    region = "us-west-2"
    key    = "alb.tfstate"
  }
  workspace = local.environment
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "thevault-db-dmps"
    region = "us-west-2"
    key    = "ecr.tfstate"
  }
  workspace = local.environment
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "thevault-db-dmps"
    region = "us-west-2"
    key    = "cluster.tfstate"
  }
  workspace = local.environment
}


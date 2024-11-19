data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "thevault-db-dmps"
    key    = "vpc.tfstate"
    region = "us-west-2"
  }
  workspace = local.environment
}

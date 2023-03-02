provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
  }

  backend "s3" {
    key            = "terraform.tfstate"
    bucket         = "my-tf-sf-bucket"
    region         = "eu-west-2"
    dynamodb_table = "tf-lock-table"
    profile        = "vscode"
  }
}

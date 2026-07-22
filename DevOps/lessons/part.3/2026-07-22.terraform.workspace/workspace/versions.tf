terraform {
  required_version = ">1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # backend "s3" {
  #   bucket               = "tf-state-620057206768"
  #   region               = "eu-central-1"
  #   workspace_key_prefix = "ws"
  #   key                  = "terraform.tfstate"
  #   # key          = "workspase/dev/terraform.tfstate"
  #   # key          = "workspase/prod/terraform.tfstate"
  #   # profile      = "packer"
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.aws_region
}

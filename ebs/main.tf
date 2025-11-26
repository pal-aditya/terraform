terraform {
  cloud {
    organization = "restart_26-11"

    workspaces {
      name = "codecamp"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
#  profile = alpha
}

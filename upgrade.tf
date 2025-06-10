terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket  = "hcl-backend-s3"
    key     = "state-files/sg.tfstate"
    region  = "us-east-1"
    profile = "alpha"
  }
}

provider "aws" {
  profile = "alpha"
  region  = "us-east-1"
}

locals {
  ingress = {
    ssh     = 22
    https   = 443
    jenkins = 8080
  }

  egress = {
    allow = 0
  }
}

resource "aws_security_group" "sg_j_hooq" {
  name        = "atif"
  vpc_id      = var.vpc_id
  description = "This is just a demo"

  tags = {
    Name = "atif-sg"
  }
}

resource "aws_security_group_rule" "sg_ingress" {
  for_each = local.ingress

  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_j_hooq.id
}

resource "aws_security_group_rule" "sg_egress" {
  for_each = local.egress

  type              = "egress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_j_hooq.id
}

output "security_group_id" {
  value = [aws_security_group.sg_j_hooq.id]
}

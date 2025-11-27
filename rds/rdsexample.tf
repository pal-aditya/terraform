resource "aws_db_instance" "rds_example"{
  instance_class = db.t3.micro
  storage_type = "gp2"
  allocated_storage = 20
  engine = "mysql"
  db_name = "restart"
  username = "alpha"
  password = "dummy"
  port = 3306
}

locals {
  inbound_port = [3306,22]
  cidr_blck = ["10.0.0.0/16"]
}

resource "aws_security_group" "restrt_sg"{
  vpc_id = var.vpc_id
  name = "restrt_sg"

  dynamic "ingress" {
    for_each = local.inbound_port
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = local.cidr_blck
    }
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.cidr_blck
  }

  tags = {
    name = "demo_sg"
  }
}

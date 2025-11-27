locals {
  inbound_ports = [3306, 22]
  allowed_cidrs = ["10.0.0.0/16"]
}

resource "aws_security_group" "restrt_sg" {
  vpc_id = var.vpc_id
  name   = "restrt_sg"

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = local.allowed_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_sg"
  }
}

# RDS instance
resource "aws_db_instance" "rds_example" {
  identifier             = "demo-rds"
  instance_class         = "db.t3.micro"
  storage_type           = "gp2"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  db_name                = "restart"
  username               = "alpha"
  password               = "dummy"
  port                   = 3306
  vpc_security_group_ids = [aws_security_group.restrt_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "demo-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "demo-rds-subnet-group"
  }
}

variable vpc_id {
  type = string
}

variable subnet_ids {
  type = list(string)
}
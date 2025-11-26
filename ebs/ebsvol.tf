resource "aws_ebs_volume" "restart_ebs" {
  tags = {
    name = "restart-ebs-vol"
  }
  size = 8
  #  region            = "ap-south-1"
  availability_zone = "ap-south-1b"
  encrypted         = true
  type              = "gp2"
}

variable vpc_id {
  type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name  = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name  = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  inbound    = [22, 80]
  cidr_block = ["0.0.0.0/0"]
}

resource "aws_security_group" "restart_sg" {
  name   = "dynamic-sg"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = local.inbound
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = local.cidr_block
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.cidr_block
  }

}

resource "aws_instance" "restart_instance" {
  #  ami_filter 
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.restart_sg.id]
}

resource "aws_volume_attachment" "restart" {
  volume_id   = aws_ebs_volume.restart_ebs.id
  instance_id = aws_instance.restart_instance.id
  device_name = "/dev/sdk"
}

resource "aws_ebs_volume" "restart_ebs" {
  tags = {
    name = "restart-ebs-vol"
  }
  size              = 8
#  region            = "ap-south-1"
  availability_zone = "ap-south-1b"
  encrypted         = true
  type              = "gp2"
}

resource "aws_instance" "restart_instance" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
}

resource "aws_volume_attachment" "restart"{
  volume_id = aws_ebs_volume.restart_ebs.id
  instance_id = aws_instance.restart_instance.id
  device_name = "/dev/sdk"
}

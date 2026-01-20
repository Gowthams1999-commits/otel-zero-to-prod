locals {

  key_name = "opentele-gow"
  common_tags = {

    managed_by = "terraform"
    project    = "otel"

  }
}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Ubuntu account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "jenkins_vm" {


  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = local.key_name

  tags = merge({


    Name = "jenkins-vm"


  }, local.common_tags)

}

output "ec2_ip" {


  value = aws_instance.jenkins_vm.id

}

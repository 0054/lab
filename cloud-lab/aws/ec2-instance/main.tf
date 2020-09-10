# Evgeny Pushkin
# kofe54@gmail.com
# github.com/0054
#
provider "aws" {}
# export AWS_ACCESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_DEFAULT_REGION="us-west-2"


# Выбираем текущий регион
data "aws_region" "current_region" {}


# Выбираем дефлотный VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name = "name"
    values = [
      "CentOS Linux 7 x86_64 HVM EBS ENA*",
    ]
  }
}



# resource "aws_key_pair" "key" {
#   key_name   = "key"
#   public_key = var.config.rsa_public_key
# }



# data "aws_ami_ids" "ubuntu" {
#   owners = "amazon"
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
#   }
# }


# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
#   filter {
#     }
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"] # Canonical
# }




# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   tags = {
#     Name = "HelloWorld"
#   }
# }

# resource "aws_security_group" "allow_ssh" {
#   name        = "allow_ssh"
#   description = "ssh"
#   vpc_id      = var.config.vpc_id
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "sec_group_ssh"
#   }
# }


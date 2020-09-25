# Evgeny Pushkin
# kofe54@gmail.com
# github.com/0054
#
provider "aws" {}
# export AWS_ACESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_DEFAULT_REGION="us-west-2"


resource "aws_instance" "web" {
  # аттачим ami
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  # аттачим ключ
  key_name = aws_key_pair.aws_key.id
  # аттачим сеьюрити группы
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "amazon_linux_t2_micro"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "open ssh port"
  # vpc_id      = data.aws_vpc.default.id
  # входящий трафик
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # исходящий трафик
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjx9/lOq+nllhmNG8NVNlSsUu5EAl6C0eGZZP4Z76xrpQZ3Tw3hwh09KljC9yjFUJa+QmtWLNU0DliaNVZvGdnBm4tGfOVchsftdTbbtNMi2bPnWe5aw1r9GUUCUEaMwU/q+iJAcEu1CZyiHDsjv5CXDgJg9Ow0XSAIPENdTj0NaIzLAzcWFFLk/Bmm7okislb02Q2En0nuZ0YMVanRtAa/kNgK14hFmCLz3gis6fNGDeHSDClFMy96IAC72yckblvsUlgG59frpLgfmJnEd+KPlL3W4fmGcb5jDozuE0ppxePyVQgUQ88/1ZDu7SpQamch50+/CBd9q5AA3crCyXT"
}

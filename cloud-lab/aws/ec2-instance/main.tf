# Evgeny Pushkin
# kofe54@gmail.com
# github.com/0054
#
provider "aws" {}
# export AWS_ACESS_KEY_ID="acesskeyid"
# export AWS_SECRET_ACESS_KEY="acesskey"
# export AWS_DEFAULT_REGION="us-west-2"


resource "aws_instance" "docker" {
  # аттачим ami
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  # аттачим ключ
  key_name = aws_key_pair.aws_key.id
  # аттачим сеьюрити группы
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # скрипт который выполняется при разворачивании сервера
  user_data = file("./user_data/docker_server.sh")

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
  ingress {
    from_port   = 80
    to_port     = 80
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
  public_key = file("../rsa/id_rsa.pub")
}

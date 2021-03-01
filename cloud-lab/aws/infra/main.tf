terraform {
  # backend "s3" {
  #   bucket = "0054-tf-remote-state"
  #   key    = "lab-state/terraform.tfstate"
  #   region = "eu-west-1"
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "lab-root"
  region  = "eu-west-1"

}

# resource "aws_instance" "example" {
#   ami           = "ami-08d70e59c07c61a3a"
#   instance_type = "t2.micro"
# }


# resource "aws_s3_bucket_policy" "terraform-state-lab-policy" {
#   bucket = aws_s3_bucket.terraform-state.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression's result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "terraform-state-lab-policy"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "s3:ListBucket"
#         Resource = "arn:aws:s3:::${aws_s3_bucket.tf-remote-state.arn}"
#       },
#       {
#         Effect   = "Allow"
#         Action   = ["s3:GetObject", "s3:PutObject"],
#         Resource = "arn:aws:s3:::${aws_s3_bucket.tf-remote-state.arn}/lab-state"
#       }
#     ]
#   })
# }


resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "0054-tf-remote-state"
  acl    = "private"
  tags = {
    Name        = "0054-tf-remote-state"
    Environment = "lab"
  }
}


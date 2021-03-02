terraform {
  backend "s3" {
    bucket         = "0054-tf-remote-state"
    key            = "lab/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "lab"
  region  = "eu-west-1"

}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Environment = "lab"
  }
}

resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "0054-tf-remote-state"
  # acl    = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = "lab"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
resource "random_uuid" "unique_id" {}

resource "aws_s3_bucket" "bucket" {
  bucket        = "artifacts-${var.bucket_name}-${random_uuid.unique_id.result}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_config" {
  depends_on = [ aws_s3_bucket.bucket ]
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  depends_on = [ aws_s3_bucket.bucket ]
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "id_account" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.15.0"
  }
}
}

provider "aws" {
  region = "us-west-1" 
}

resource "random_id" "bucket_name" {
  prefix     = "static-website-"
  byte_length = 3
}

resource "aws_s3_bucket" "static-website-bucket" {
  bucket = random_id.bucket_name.hex


  tags = {
    Name        = "StaticWebsite"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.static-website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.static-website-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.static-website-bucket.id
    key    = "index.html"
    source = "../website-src/index.html"
    content_type = "text/html"
    etag   = filemd5("../website-src/index.html")
}

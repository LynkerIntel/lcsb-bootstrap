# Data sources for S3 buckets
data "aws_s3_bucket" "inputs_bucket" {
  bucket = aws_s3_bucket.inputs_bucket.bucket
}

data "aws_s3_bucket" "outputs_bucket" {
  bucket = aws_s3_bucket.outputs_bucket.bucket
}

data "aws_s3_bucket" "transfer_bucket" {
  bucket = aws_s3_bucket.transfer_bucket.bucket
}
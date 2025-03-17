output "bucket_name" {
  value = aws_s3_bucket.state_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.state_bucket.arn
}

output "aws_vpc_vpc_lcsb_id" {
  value = aws_vpc.vpc_lcsb.id
}


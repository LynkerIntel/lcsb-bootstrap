output "bucket_name" {
  value = aws_s3_bucket.state_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.state_bucket.arn
}

output "env_vpc_id" {
  value = aws_vpc.env_vpc.id
}

output "public_subnets" {
  value = { for s in aws_subnet.public_subnets : s.availability_zone => {
    id         = s.id
    cidr_block = s.cidr_block
  } }
}

output "private_subnet_ids" {
  value = { for s in aws_subnet.private_subnets : s.availability_zone => {
    id         = s.id
    cidr_block = s.cidr_block
  } }
}

output "aws_security_group_sg" {
  value = aws_default_security_group.sg_vpc_def_env.id
}

output "dynamodb_lock_table" {
  value = aws_dynamodb_table.tfstate_lock_db.name
}
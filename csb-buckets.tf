locals {
  iot_role_name = "${var.environment}-iot-role"
}
# Define S3 buckets
resource "aws_s3_bucket" "inputs_bucket" {
  bucket = "${var.environment}-inputs"
  tags = {
    Name = "${var.environment} Inputs Bucket"
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags]
  }

}

resource "aws_s3_bucket" "outputs_bucket" {
  bucket = "${var.environment}-outputs"
  tags = {
    Name = "${var.environment} Outputs Bucket"
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket" "transfer_bucket" {
  bucket = "${var.environment}-transfer"
  tags = {
    Name = "${var.environment} Transfer Bucket"
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags]
  }
}

# IAM Roles and Instance Profiles for each bucket
# resource "aws_iam_role" "ssm_role" {
#   name = "${var.environment}-iot-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#           Condition= {
#             StringEquals = {
#               "sts:ExternalId" = "ec2.amazonaws.com"
#             }
#           }
#       }
#     ]
#   })
# }

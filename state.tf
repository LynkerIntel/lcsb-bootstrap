locals {
  actual_bucket = var.use_env_in_bucket_name ? "${var.environment}-${var.bucket_name}" : var.bucket_name
}
data "aws_iam_roles" "specific_role_search" {
  name_regex = var.role_name_regex
}

locals {
  role_arn = tolist(data.aws_iam_roles.specific_role_search.arns)[0]
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.actual_bucket
  lifecycle {
    # prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "state_bucket_policy" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSpecificRole"
        Effect = "Allow"
        Principal = {
          AWS = local.role_arn
        }
        Action   = "s3:*"
        Resource = "${aws_s3_bucket.state_bucket.arn}/*"
      },
      {
        Sid    = "DenyAllOthers"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        }
        Action   = "s3:*"
        Resource = "${aws_s3_bucket.state_bucket.arn}/*"
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn" = local.role_arn
          }
        }
      }
    ]
  })
}

resource "aws_dynamodb_table" "tfstate_lock_db" {
  name         = "${var.environment}-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


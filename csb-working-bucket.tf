# Define S3 buckets
resource "aws_s3_bucket" "csb_working" {
  bucket = "${var.environment}-cloud-sandbox-working"



  force_destroy = true
  tags = {
    Name = "${var.environment} Cloud Sandbox Working Bucket"
  }
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_ownership_controls" "csb_working" {
  bucket = aws_s3_bucket.csb_working.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.csb_working]
}

resource "aws_s3_bucket_public_access_block" "csb_working" {
  bucket = aws_s3_bucket.csb_working.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.csb_working.id
  policy = data.aws_iam_policy_document.csb_working.json
}
data "aws_iam_policy_document" "csb_working" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      aws_s3_bucket.csb_working.arn,
      "${aws_s3_bucket.csb_working.arn}/*"
    ]
    actions = ["s3:*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.csb_working]
}



# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.csb_working.id
#   acl     = "public-read-write"
# }


# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "csb_www" {
  bucket = aws_s3_bucket.csb_working.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 bucket CORS configuration
resource "aws_s3_bucket_cors_configuration" "csb_cors" {
  bucket = aws_s3_bucket.csb_working.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# S3 bucket versioning configuration
resource "aws_s3_bucket_versioning" "csb_working_versioning" {
  bucket = aws_s3_bucket.csb_working.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "csb_working_lifecycle" {
  bucket = aws_s3_bucket.csb_working.id

  rule {
    id     = "lifecycle-rule"
    status = "Enabled"
    filter {
      prefix = ""
    }
    # Move to infrequent access after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Move to glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Expire current version after 366 days
    expiration {
      days = 366
    }

    # Handle noncurrent versions
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# IAM Policies

resource "aws_iam_policy" "csb_working_readwrite_policy" {
  name        = "${var.environment}-working-readwrite-policy"
  description = "Read and write access to working bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.csb_working.arn,
          "${aws_s3_bucket.csb_working.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_object" "csb_working_index" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "index.html"
  content      = var.index_html
  content_type = "text/html"
  etag         = md5(var.index_html)
}

resource "aws_s3_object" "csb_working_err" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "error.html"
  content      = var.error_html
  content_type = "text/html"
  etag         = md5(var.error_html)
}


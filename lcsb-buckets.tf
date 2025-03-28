# Define S3 buckets
resource "aws_s3_bucket" "inputs_bucket" {
    bucket = "${var.environment}-inputs"
    tags = {
        Name = "${var.environment} Inputs Bucket"
    }
}

resource "aws_s3_bucket" "outputs_bucket" {
    bucket = "${var.environment}-outputs"
    tags = {
        Name = "${var.environment} Outputs Bucket"
    }
}

resource "aws_s3_bucket" "transfer_bucket" {
    bucket = "${var.environment}-transfer"
    tags = {
        Name = "${var.environment} Transfer Bucket"
    }
}

# IAM Roles and Instance Profiles for each bucket
resource "aws_iam_role" "inputs_role" {
  name = "${var.environment}-inputs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "outputs_role" {
  name = "${var.environment}-outputs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "transfer_role" {
  name = "${var.environment}-transfer-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policies
resource "aws_iam_policy" "inputs_read_policy" {
  name        = "${var.environment}-inputs-read-policy"
  description = "Read-only access to inputs bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.inputs_bucket.arn,
          "${aws_s3_bucket.inputs_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "outputs_write_policy" {
  name        = "${var.environment}-outputs-write-policy"
  description = "Write-only access to outputs bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.outputs_bucket.arn,
          "${aws_s3_bucket.outputs_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "transfer_readwrite_policy" {
  name        = "${var.environment}-transfer-readwrite-policy"
  description = "Read and write access to transfer bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.transfer_bucket.arn,
          "${aws_s3_bucket.transfer_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "inputs_policy_attach" {
  role       = aws_iam_role.inputs_role.name
  policy_arn = aws_iam_policy.inputs_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "outputs_policy_attach" {
  role       = aws_iam_role.outputs_role.name
  policy_arn = aws_iam_policy.outputs_write_policy.arn
}

resource "aws_iam_role_policy_attachment" "transfer_policy_attach" {
  role       = aws_iam_role.transfer_role.name
  policy_arn = aws_iam_policy.transfer_readwrite_policy.arn
}

# Instance profiles
resource "aws_iam_instance_profile" "inputs_profile" {
  name = "${var.environment}-inputs-profile"
  role = aws_iam_role.inputs_role.name
}

resource "aws_iam_instance_profile" "outputs_profile" {
  name = "${var.environment}-outputs-profile"
  role = aws_iam_role.outputs_role.name
}

resource "aws_iam_instance_profile" "transfer_profile" {
  name = "${var.environment}-transfer-profile"
  role = aws_iam_role.transfer_role.name
    }


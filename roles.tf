
resource "aws_iam_role" "iot_role" {
  name = local.iot_role_name

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

#TODO If the ssm_connect_policy doesn't work properly, maybe this one will
data "aws_iam_policy" "ssm_connect_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_policy" "ssm_connect_policy" {
#   name_prefix = "vm"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ssmmessages:CreateDataChannel",
#           "ssmmessages:OpenDataChannel",
#           "ssmmessages:CreateControlChannel",
#           "ssmmessages:OpenControlChannel",
#           "ssm:UpdateInstanceInformation",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }
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
          data.aws_s3_bucket.inputs_bucket.arn,
          "${data.aws_s3_bucket.inputs_bucket.arn}/*"
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
          data.aws_s3_bucket.outputs_bucket.arn,
          "${data.aws_s3_bucket.outputs_bucket.arn}/*"
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
          data.aws_s3_bucket.transfer_bucket.arn,
          "${data.aws_s3_bucket.transfer_bucket.arn}/*"
        ]
      }
    ]
  })
}


# Attach policies to roles

resource "aws_iam_policy" "ec2_pass_role" {
  name        = "${var.environment}-pass-role-policy"
  description = "Read and write access to transfer bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        "Action" : [
          "ec2:RunInstances",
          "iam:PassRole"
        ],
        "Resource" : [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iot_role_name}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "inputs_policy_attach" {
  role       = aws_iam_role.inputs_role.name
  policy_arn = aws_iam_policy.inputs_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "iot_policy_attach_o" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.outputs_write_policy.arn
}
resource "aws_iam_role_policy_attachment" "outputs_policy_attach" {
  role       = aws_iam_role.outputs_role.name
  policy_arn = aws_iam_policy.outputs_write_policy.arn
}
resource "aws_iam_role_policy_attachment" "iot_policy_attach_t" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.transfer_readwrite_policy.arn
}

resource "aws_iam_role_policy_attachment" "transfer_policy_attach" {
  role       = aws_iam_role.transfer_role.name
  policy_arn = aws_iam_policy.transfer_readwrite_policy.arn
}

resource "aws_iam_role_policy_attachment" "working_policy_attach" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.csb_working_readwrite_policy.arn
}

resource "aws_iam_role_policy_attachment" "sss_policy_attach" {
  role       = aws_iam_role.iot_role.name
  policy_arn = data.aws_iam_policy.ssm_connect_policy.arn
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

resource "aws_iam_instance_profile" "head_node_profile" {
  name = "${var.environment}-head-node-profile"
  role = aws_iam_role.iot_role.name
}


resource "aws_iam_role_policy_attachment" "head_node_role_policy_attach_profile" {
  count      = length(var.managed_policies)
  policy_arn = element(var.managed_policies, count.index)
  role       = aws_iam_role.iot_role.name
}

resource "aws_iam_role_policy_attachment" "pass_role_attach" {
  role       = aws_iam_role.iot_role.name
  policy_arn = aws_iam_policy.ec2_pass_role.arn
}


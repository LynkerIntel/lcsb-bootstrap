variable "profile" {
  description = "The AWS profile to use that maps to var.role_name_regex"
  type        = string
  default     = "csb-admin"
}

variable "target_az" {
  description = "The target availability zone for the instance"
  type        = string
  default     = "us-east-2b"
}
variable "owner" {
  description = "The owner of the infrastructure"
  type        = string
  default     = "Lynker"
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Name of environment"
  type        = string
  default     = "csb"
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "terraform-state"
}

variable "use_env_in_bucket_name" {
  description = "Whether to include the environment in the bucket name"
  type        = bool
  default     = true
}

# variable "account_id" {
#   description = "The AWS account ID"
#   type        = string
#   default     = "571600850629"
# }

variable "role_name_regex" {
  description = "The name of the IAM role regex (for matching in different accounts)"
  type        = string
  default     = "AWSReservedSSO_AWSAdministratorAccess.*"
}

# variable "availability_zones" {
#   description = "The availability zones to create resources in"
#   type        = list(string)
#   default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
# }
# variable "private_subnet_cidrs" {
#   description = "The CIDR blocks for the private subnets"
#   type        = list(string)
#   default     = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
# }
# variable "public_subnet_cidrs" {
#   description = "The CIDR blocks for the public subnets"
#   type        = list(string)
#   default     = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
# }

# TODO This probably needs some work
variable "subnet_map" {
  default = {
    us-east-2a = {
      public  = "172.31.0.0/20"
      private = "172.31.48.0/20"
    }
    us-east-2b = {
      public  = "172.31.16.0/20"
      private = "172.31.64.0/20"
    }
    us-east-2c = {
      public  = "172.31.32.0/20"
      private = "172.31.80.0/20"
  } }
}


variable "managed_policies" {
  description = "The attached IAM policies granting machine permissions"
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonFSxFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

variable "index_html" {
  description = "The content of the index.html file"
  type        = string
  default     = "<h1>Why are you here?</h1><p>There is nothing to see here.</p>"

}
variable "error_html" {
  description = "The content of the error.html file"
  type        = string
  default     = "<h1>No, seriously.  Why are you here?</h1><p>There is LITERALLY nothing to see here.</p>"

}
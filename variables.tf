variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Name of environment"
  type        = string
  default     = "lcsb"
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "lcsb-terraform-state"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "571600850629"
}

variable "role_name_regex" {
  description = "The name of the IAM role regex (for matching in different accounts)"
  type        = string
  default     = "AWSReservedSSO_AWSAdministratorAccess.*"
}

variable "availability_zones" {
  description = "The availability zones to create resources in"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
}
variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
}

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
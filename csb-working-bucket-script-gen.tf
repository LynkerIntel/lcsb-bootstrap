locals {
  environment = var.environment
  sni         = aws_subnet.public_subnets[var.target_az].id
  scriptvars = {
    region      = var.region
    env         = var.environment
    bucket_name = aws_s3_bucket.csb_working.bucket
    bucket_arn  = aws_s3_bucket.csb_working.arn
    bucket_url  = aws_s3_bucket_website_configuration.csb_www.website_endpoint
    bucket_id   = aws_s3_bucket.csb_working.id
  }

  env_script        = <<-EOT
    #!/bin/bash
    # This can be downloaded and used as a .envrc for a project
    export AWS_REGION=${var.region}
    export CSB_WORKING_BUCKET=${aws_s3_bucket.csb_working.bucket}
    export CSB_WORKING_BUCKET_ARN=${aws_s3_bucket.csb_working.arn}
    export CSB_WORKING_BUCKET_URL=${aws_s3_bucket_website_configuration.csb_www.website_endpoint}
    export PKR_VAR_vpc=${aws_vpc.env_vpc.id}
    export PKR_VAR_region=$${AWS_REGION}
    export PKR_VAR_env=${var.environment}
    export PKR_VAR_state_bucket_name=${aws_s3_bucket.state_bucket.bucket}
    export PKR_VAR_state_bucket_arn=${aws_s3_bucket.state_bucket.arn}
    export PKR_VAR_bucket_name=$${CSB_WORKING_BUCKET} # Set to env var name for override purposes
    export PKR_VAR_bucket_arn=$${CSB_WORKING_BUCKET_ARN} # Set to env var name for override purposes
    export PKR_VAR_state_lock_table=${aws_dynamodb_table.tfstate_lock_db.id}
    export PKR_VAR_subnet_id=${local.sni}
    export PKR_VAR_profile=${var.profile}
    EOT
  properties_script = <<-EOTPROPS
    # This is a properties file that can be used for tfvars, etc
    vpc="${aws_vpc.env_vpc.id}"
    region="${var.region}"
    env="${var.environment}"
    state_bucket_name="${aws_s3_bucket.state_bucket.bucket}"
    state_bucket_arn="${aws_s3_bucket.state_bucket.arn}"
    bucket_name="${aws_s3_bucket.csb_working.bucket}"
    bucket_arn="${aws_s3_bucket.csb_working.arn}"
    state_lock_table="${aws_dynamodb_table.tfstate_lock_db.id}"
    subnet_id="${local.sni}"
    profile="${var.profile}"
  EOTPROPS

  providers_tf_script = <<-EOTTF
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.9"
        }
      }
      provider "aws" {
        region  = var.region
        profile = var.profile
        default_tags {
          tags = {
            Environment = var.environment
            Owner       = var.owner
          }
        }
      }

      backend "s3" {
        bucket         = "@state_bucket_name@"
        key            = "tfstate/@env@/terraform.tfstate"
        region         = "@region@"
        dynamodb_table = "@state_lock_table@"
        encrypt        = true
      }
    }

  EOTTF
}

resource "aws_s3_object" "csb_environment_script" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "${var.environment}/DOTENVRC"
  content      = local.env_script # templatefile("environment.tftpl", locals)
  content_type = "text/plain"
  etag         = md5(local.env_script) # md5(local.environment)
}
resource "aws_s3_object" "csb_properties_script" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "${var.environment}/${var.environment}.auto.tfvars"
  content      = local.properties_script
  content_type = "text/plain"
  etag         = md5(local.properties_script)
}
resource "aws_s3_object" "providers_template" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "${var.environment}/PROVIDERS.bdt"
  content      = local.providers_tf_script
  content_type = "text/plain"
  etag         = md5(local.providers_tf_script)
}
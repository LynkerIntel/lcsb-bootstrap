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
    export PKR_VAR_bucket_name=$${CSB_WORKING_BUCKET} # Set to env var name for override purposes
    export PKR_VAR_bucket_arn=$${CSB_WORKING_BUCKET_ARN} # Set to env var name for override purposes
    export PKR_VAR_subnet_id=${local.sni}
    export PKR_VAR_profile=${var.profile}
    EOT
  properties_script = <<-EOTPROPS
    # This is a properties file that can be used for tfvars, etc
    vpc=${aws_vpc.env_vpc.id}
    region=${var.region}
    env=${var.environment}
    bucket_name=${aws_s3_bucket.csb_working.bucket}
    bucket_arn=${aws_s3_bucket.csb_working.arn}
    subnet_id=${local.sni}
    profile=${var.profile}
  EOTPROPS
}

resource "aws_s3_object" "csb_environment_script" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "DOTENVRC"
  content      = local.env_script # templatefile("environment.tftpl", locals)
  content_type = "text/plain"
  etag         = md5(local.env_script) # md5(local.environment)
}
resource "aws_s3_object" "csb_properties_script" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "env.properties"
  content      = local.properties_script
  content_type = "text/plain"
  etag         = md5(local.properties_script)
}
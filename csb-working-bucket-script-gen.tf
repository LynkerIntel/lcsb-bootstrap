locals {
  environment = var.environment
  scriptvars = {
    region      = var.region
    env         = var.environment
    bucket_name = aws_s3_bucket.csb_working.bucket
    bucket_arn  = aws_s3_bucket.csb_working.arn
    bucket_url  = aws_s3_bucket_website_configuration.csb_www.website_endpoint
    bucket_id   = aws_s3_bucket.csb_working.id
  }

  env_script = <<-EOT
    #!/bin/bash
    export AWS_REGION=${var.region}
    export CSB_WORKING_BUCKET=${aws_s3_bucket.csb_working.bucket}
    export CSB_WORKING_BUCKET_ARN=${aws_s3_bucket.csb_working.arn}
    export CSB_WORKING_BUCKET_URL=${aws_s3_bucket_website_configuration.csb_www.website_endpoint}
    expork PKR_VAR_vpc=${aws_vpc.csb_vpc.id}
    export PKR_VAR_region=${AWS_REGION}
    export PKR_VAR_env=${var.environment}
    export PKR_VAR_bucket_name=${CSB_WORKING_BUCKET}
    export PKR_VAR_bucket_arn=${CSB_WORKING_BUCKET_ARN}
    export PKR_VAR_subnet_id=${aws_subnet.csb_subnet.id}
    export PKR_VAR_profile=${var.profile}
    EOT
}

resource "aws_s3_object" "csb_environment_script" {
  bucket       = aws_s3_bucket.csb_working.id
  key          = "env.sh"
  content      = local.env_script # templatefile("environment.tftpl", locals)
  content_type = "text/plain"
  etag         = md5(local.env_script) # md5(local.environment)
}
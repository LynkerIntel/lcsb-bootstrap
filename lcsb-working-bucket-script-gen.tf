locals {
  environment = var.environment
  scriptvars = {
    region      = var.region
    env         = var.environment
    bucket_name = aws_s3_bucket.lcsb_working.bucket
    bucket_arn  = aws_s3_bucket.lcsb_working.arn
    bucket_url  = aws_s3_bucket_website_configuration.lcsb_www.website_endpoint
    bucket_id   = aws_s3_bucket.lcsb_working.id
  }

  env_scritpt = <<-EOT
    #!/bin/bash
    export AWS_REGION=${var.region}
    export LCSB_WORKING_BUCKET=${aws_s3_bucket.lcsb_working.bucket}
    export LCSB_WORKING_BUCKET_ARN=${aws_s3_bucket.lcsb_working.arn}
    export LCSB_WORKING_BUCKET_URL=${aws_s3_bucket_website_configuration.lcsb_www.website_endpoint}
    EOT
}

resource "aws_s3_object" "lcsb_environment_script" {
  bucket       = aws_s3_bucket.lcsb_working.id
  key          = "env.sh"
  content      = local.env_scritpt # templatefile("environment.tftpl", locals)
  content_type = "text/plain"
  etag         = md5(local.env_scritpt) # md5(local.environment)
}
# Example Configs

```
terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = "tfstate/some/other/statefile"
    region         = var.region
    dynamodb_table = "tfstate_lock_db"
    encrypt        = true
  }
}

```
# Other

```
terraform {
  backend "s3" {
    profile        = var.profile
    bucket         = "csb-terraform-state"
    key            = "tfstate/${var.project}/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "csb-terraform-state-lock"
  }
}
```

# Remote State 
This will work, because `csb-terraform-state` is a real bucket.  The region and lock table exist, and
you would need to set your profile as a variable.

```
data "terraform_remote_state" "bootstrap" {
 backend = "s3"
 config = {
   profile = "csb-admin"
   bucket = "csb-terraform-state"
   key    = "tfstate/csb-bootstrap/terraform.tfstate"
   region = "us-east-2"
 }
}

# You don't need a locals, you can just read the vpc directly using `data.terraform_remote_state.bootstrap.outputs.env_vpc_id`
locals {
    ab = data.terraform_remote_state.bootstrap.outputs.bucket_name
    vv = data.terraform_remote_state.bootstrap.outputs.env_vpc_id
}
```
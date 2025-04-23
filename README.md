# cloud-sandbox-boostrap
Repo for bootstrapping the Cloud Sandbox

This project 
- sets up an S3 bucket with a specific bucket policy using Terraform
- creates DynamoDB for state locking.  This is always named `"{var.environment}-state-lock`

For the CSB it also: 

- builds a VPC that tries to conform to the target environment while being independent enough to allow work to be done freely.


## Requirements

- OpenTofu installed on your machine.  Terraform also works.
- AWS account with appropriate permissions

## Setup Instructions

1. **Clone the repository:**
   ```
   git clone <repository-url> cloud-sandbox-bootstrap
   cd cloud-sandbox-bootstrap
   ```

2. **Initialize Terraform:**
   ```
   tofu init
   ```

3. **Configure variables:**
   Update the `variables.tf` file with your desired bucket name, AWS account ID, and role ARNs or create a `cloud-sandbox.tfvars`

   Configurable items are:

   - `owner` for who gets to destroy this, if desired
   - `region` for the AWS region to use
   - `environment` for the name of this target environment
   - `bucket_name` which must often be overridden unless you `use_env_in_bucket_name`
   - `use_env_in_bucket_name` if you want the environment name to be prepended to the state bucket name
   - `role_name_regex` is the regex to use to search for the role that should be allowed to write to the state bucket.  The system uses the first returned result, so this should return exactly one.
   - `subnet_map` is a map(map(string)).  The top level is the AZ name to build a subnet.  For each subnet, if there is a `public` key in the submap, then it should point to the CIDR of a public network.  Same for a `private` key and private network.

   These all have reasonable defaults.  For elements that are not "production" CSB, the environment should be changed to something else and the bucket name adjusted, if desired.

4. **Plan the deployment:**
   ```
   tofu plan
   ```

5. **Apply the configuration:**
   ```
   tofu apply
   ```

6. **Check outputs:**
   After applying, you can see the outputs for the bucket name and ARN.

## Cleanup

To remove all resources created by this project:

First, you must change all instances of `prevent_destroy = true` to `prevent_destroy = false` in the `lifecycle` configurations.

Then you can 
```
terraform destroy
``` 

## Notes

Ensure that your AWS credentials are configured properly in your environment for OpenTofu to access your AWS account.

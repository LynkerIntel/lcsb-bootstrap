# lcsb-boostrap
Repo for bootstrapping Lynker's Cloud Sandbox Parity Account

This project 
- sets up an S3 bucket with a specific bucket policy using Terraform
- creates DynamoDB for state locking
- builds a VPC that tries to conform to the target environment while being independent


## Requirements

- Terraform installed on your machine.  OpenTofu works.
- AWS account with appropriate permissions

## Setup Instructions

1. **Clone the repository:**
   ```
   git clone <repository-url> Lynker-CSB-Bootstrap
   cd Lynker-CSB-Bootstrap
   ```

2. **Initialize Terraform:**
   ```
   terraform init
   ```

3. **Configure variables:**
   Update the `variables.tf` file with your desired bucket name, AWS account ID, and role ARNs or create a `lcsb.tfvars`

4. **Plan the deployment:**
   ```
   terraform plan
   ```

5. **Apply the configuration:**
   ```
   terraform apply
   ```

6. **Check outputs:**
   After applying, you can see the outputs for the bucket name and ARN.

## Cleanup

To remove all resources created by this project, run:
```
terraform destroy
``` 

## Notes

Ensure that your AWS credentials are configured properly in your environment for Terraform to access your AWS account.

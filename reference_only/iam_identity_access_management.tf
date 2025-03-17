# resource "aws_iam_access_key" "akiaz24itc6rbtuhfu3n" {
#   status = "Active"
#   user   = aws_iam_user.test_user.name
# }

# resource "aws_iam_group" "administrators" {
#   name = "Administrators"
#   path = "/"
# }

# resource "aws_iam_group_membership" "administrators" {
#   group = "Administrators"
#   name  = ""
#   users = [aws_iam_user.test_user.name]
# }

# resource "aws_iam_group_policy_attachment" "administrators_arn_aws_iam__aws_policy_administratoraccess" {
#   group      = aws_iam_group.administrators.id
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

# resource "aws_iam_role" "awsserviceroleforsupport" {
#   assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"support.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
#   description        = "Enables resource access for AWS to provide billing, administrative and support services"
#   inline_policy {
#   }

#   managed_policy_arns  = ["arn:aws:iam::aws:policy/aws-service-role/AWSSupportServiceRolePolicy"]
#   max_session_duration = 3600
#   name                 = "AWSServiceRoleForSupport"
#   path                 = "/aws-service-role/support.amazonaws.com/"
# }

# resource "aws_iam_role" "awsservicerolefortrustedadvisor" {
#   assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"trustedadvisor.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
#   description        = "Access for the AWS Trusted Advisor Service to help reduce cost, increase performance, and improve security of your AWS environment."
#   inline_policy {
#   }

#   managed_policy_arns  = ["arn:aws:iam::aws:policy/aws-service-role/AWSTrustedAdvisorServiceRolePolicy"]
#   max_session_duration = 3600
#   name                 = "AWSServiceRoleForTrustedAdvisor"
#   path                 = "/aws-service-role/trustedadvisor.amazonaws.com/"
# }

# resource "aws_iam_role_policy_attachment" "awsserviceroleforsupport_arn_aws_iam__aws_policy_aws_service_role_awssupportservicerolepolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSSupportServiceRolePolicy"
#   role       = aws_iam_role.awsserviceroleforsupport.id
# }

# resource "aws_iam_role_policy_attachment" "awsservicerolefortrustedadvisor_arn_aws_iam__aws_policy_aws_service_role_awstrustedadvisorservicerolepolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSTrustedAdvisorServiceRolePolicy"
#   role       = aws_iam_role.awsservicerolefortrustedadvisor.id
# }

# resource "aws_iam_user" "test_user" {
#   name = "test-user"
#   path = aws_iam_group.administrators.path
# }


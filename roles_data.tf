# Data sources for IAM instance profiles
data "aws_iam_instance_profile" "inputs_profile" {
    name = "${var.environment}-inputs-profile"
    depends_on = [aws_iam_instance_profile.inputs_profile]
}

data "aws_iam_instance_profile" "outputs_profile" {
    name = "${var.environment}-outputs-profile"
    depends_on = [aws_iam_instance_profile.outputs_profile]
}

data "aws_iam_instance_profile" "transfer_profile" {
    name = "${var.environment}-transfer-profile"
    depends_on = [aws_iam_instance_profile.transfer_profile]
}

data "aws_iam_instance_profile" "head_node_profile" {
    name = "${var.environment}-head-node-profile"
    depends_on = [aws_iam_instance_profile.head_node_profile]
}

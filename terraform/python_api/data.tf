data "aws_iam_policy_document" "lambda_permissions" {

  statement {
    sid    = "AllowDynamoDB"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      module.dynamodb_vpcs_table.dynamodb_table_arn,
      module.dynamodb_networks_table.dynamodb_table_arn
    ]
  }

  statement {
    sid    = "AllowEC2VpcManagement"
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:DescribeVpcs",
      "ec2:CreateSubnet",
      "ec2:DescribeSubnets",
      "ec2:CreateTags"
    ]
    resources = [
      module.lambda.lambda_function_arn
    ]
  }
}
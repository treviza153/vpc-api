module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.6.1"

  name = "${var.name}-role"

  trust_policy_permissions = {
    LambdaAssume = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }]
    }
  }

  tags = var.tags
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.6.1"

  name   = "${var.name}-policy"
  policy = var.policy_document

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = module.iam_role.name
  policy_arn = module.iam_policy.arn
}

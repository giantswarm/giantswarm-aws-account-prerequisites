# control-plane account-specific resources

# import the generic resources module
module "generic-resources" {
  source = "../generic-resources"
}

resource "aws_iam_user" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
}

resource "aws_iam_user_policy_attachment" "giantswarm-aws-operator-user" {
  user       = aws_iam_user.giantswarm-aws-operator.name
  policy_arn = module.generic-resources.iam-policy-arn
}

resource "aws_iam_access_key" "giantswarm-aws-operator-user" {
  user    = aws_iam_user.giantswarm-aws-operator.name
}

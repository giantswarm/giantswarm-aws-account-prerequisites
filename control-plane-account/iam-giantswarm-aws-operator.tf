# control-plane account-specific resources

resource "aws_iam_user" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-operator-user" {
  role       = aws_iam_user.giantswarm-aws-operator.name
  policy_arn = aws_iam_policy.giantswarm-aws-operator.arn
}

resource "aws_iam_access_key" "giantswarm-aws-operator-user" {
  user    = aws_iam_user.giantswarm-aws-operator.name
}

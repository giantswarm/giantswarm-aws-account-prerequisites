### Control Plane AWS operator User ###
resource "aws_iam_user" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
}

resource "aws_iam_policy" "giantswarm-policy" {
  name   = "GiantSwarmUserAWSOperator"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_user_policy_attachment" "giantswarm-aws-operator-user" {
  user       = aws_iam_user.giantswarm-aws-operator.name
  policy_arn = aws_iam_policy.giantswarm-policy.arn
}

resource "aws_iam_access_key" "giantswarm-aws-operator-user" {
  user    = aws_iam_user.giantswarm-aws-operator.name
}
### END Control Plane AWS operator User ###

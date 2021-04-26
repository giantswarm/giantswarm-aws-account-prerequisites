resource "aws_iam_user" "giantswarm-aws-capa-controller" {
  name = "GiantSwarmAWSCapaController"
}

resource "aws_iam_policy" "giantswarm-policy" {
  name   = "GiantSwarmUserAWSCapaController"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_user_policy_attachment" "giantswarm-aws-capa-controller-user" {
  user       = aws_iam_user.giantswarm-aws-capa-controller.name
  policy_arn = aws_iam_policy.giantswarm-policy.arn
}

resource "aws_iam_access_key" "giantswarm-aws-operator-user" {
  user = aws_iam_user.giantswarm-aws-operator.name
}

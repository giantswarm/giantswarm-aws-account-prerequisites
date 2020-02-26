resource "aws_iam_role" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

data "aws_iam_policy_document" "giantswarm-aws-operator" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principal_arns_aws_operator
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name   = "GiantSwarmAWSOperatorPolicy"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-operator" {
    role       = aws_iam_role.giantswarm-aws-operator.name
    policy_arn = aws_iam_policy.giantswarm-aws-operator.arn
}


locals {
  operator_role_name = "GiantSwarmAWSOperator"
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name = local.operator_role_name
  policy = templatefile("${path.module}/iam-policy.json", {
    account_id = "${var.target_account_id}"
    arn_prefix = "${var.arn_prefix}"
  })
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name               = local.operator_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-operator" {
  role       = aws_iam_role.giantswarm-aws-operator.name
  policy_arn = aws_iam_policy.giantswarm-aws-operator.arn
}

data "aws_iam_policy_document" "giantswarm-aws-operator" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${var.arn_prefix}:iam::${var.main_account_id}:user/${var.operator_user_name}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

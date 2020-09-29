### AWS Operator Role ###
# Get latest policy

resource "aws_iam_role" "giantswarm-aws-operator" {
  name               = var.operator_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name   = var.operator_role_name
  policy = replace(file("${path.module}/iam-policy.json"), "<CUSTOMER_ACCOUNT_ID>", var.target_account_id)
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
      identifiers = ["arn:aws:iam::${var.main_account_id}:user/${var.operator_user_name}"]
    }

    actions = ["sts:AssumeRole"]
  }
}
### AWS Operator Role ###

### AWS Operator Role ###
# Get latest policy

data "local_file" "policy" {
  filename = "${path.module}/files/policy.json"
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name               = var.operator_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name   = var.operator_role_name
  policy = replace(data.local_file.policy.content, "<CUSTOMER_ACCOUNT_ID>", var.tenant_account_id)
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
      identifiers = ["arn:aws:iam::${var.main_account_id}:user/GiantSwarmAWSOperator"]
    }

    actions = ["sts:AssumeRole"]
  }
}
### AWS Operator Role ###

### AWS Operator Role ###
# Get latest policy

data "http" "policy-file" {
  #url = "https://raw.githubusercontent.com/giantswarm/aws-operator/master/policies/aws-operator.json"
  url = "https://raw.githubusercontent.com/giantswarm/aws-operator/8fb3ab3234489878dac30a138dd475f7972fe78e/policies/tenant_cluster.json"
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name               = var.operator_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name   = var.operator_policy_name
  policy = replace(data.http.policy-file.body, "<CUSTOMER_ACCOUNT_ID>", var.target_account_id)
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

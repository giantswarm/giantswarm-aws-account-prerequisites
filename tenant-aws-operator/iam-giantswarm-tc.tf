### AWS Operator Role ###
# Get latest policy
resource "null_resource" "aws-operator-policy" {
  provisioner "local-exec" {
    # Download last upgrade policy
    command = "${path.module}/upgrade_policy.sh ${var.tenant_account_id}"
  }
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_policy" "giantswarm-aws-operator" {
  name   = "GiantSwarmAWSOperatorPolicy"
  policy = file("${path.module}/iam-policy.json")
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
      identifiers = ["arn:aws:iam::${var.main_account_id}:root]
    }

    actions = ["sts:AssumeRole"]
  }
}
### AWS Operator Role ###

# tenant cluster account-specific resources

# get latest policy
resource "null_resource" "aws-operator-policy" {
  provisioner "local-exec" {
    # Download last upgrade policy
    command = "${path.module}/upgrade_policy.sh ${var.tenant_account_id}"
  }
}

# import the generic resources module
module "generic-resources" {
  source = "../generic-resources"
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
  assume_role_policy = data.aws_iam_policy_document.giantswarm-aws-operator.json
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-operator" {
  role       = aws_iam_role.giantswarm-aws-operator.name
  policy_arn = module.generic-resources.iam-policy-arn
}

data "aws_iam_policy_document" "giantswarm-aws-operator" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.main_account_id}:role/GiantSwarmAWSOperator"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# control-plane account-specific resources

# get latest policy
resource "null_resource" "aws-operator-policy" {
  provisioner "local-exec" {
    # Download last upgrade policy
    command = "${path.module}/upgrade_policy.sh ${var.main_account_id}"
  }
}

# import the generic resources module
module "generic-resources" {
  source = "../generic-resources"
}

resource "aws_iam_role" "giantswarm-aws-operator" {
  name = "GiantSwarmAWSOperator"
}

resource "aws_iam_role_policy_attachment" "giantswarm-aws-operator-role" {
  role       = aws_iam_role.giantswarm-aws-operator.name
  policy_arn = module.generic-resources.iam-policy-arn
}

resource "aws_iam_access_key" "giantswarm-aws-operator-role" {
  role    = aws_iam_role.giantswarm-aws-operator.name
}

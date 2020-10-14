resource "aws_iam_role" "giantswarm-admin" {
  name               = var.admin_role_name
  assume_role_policy = data.aws_iam_policy_document.giantswarm-admin.json
}

data "aws_iam_policy_document" "giantswarm-admin" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principal_arns_giantswarm_root_account
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-admin-policy" {
  name   = "GiantSwarmAdmin"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "giantswarm-policy-attachment" {
  role       = aws_iam_role.giantswarm-admin.name
  policy_arn = aws_iam_policy.giantswarm-admin-policy.arn
}

### Admin Staff Role ###
resource "aws_iam_role" "giantswarm" {
  name = "GiantSwarmAdmin"
  assume_role_policy = data.aws_iam_policy_document.giantswarm.json
}

data "aws_iam_policy_document" "giantswarm" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principal_arns_giantswarm
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-policy" {
  name   = "GiantSwarmAdminPolicy"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "giantswarm-policy-attachment" {
    role       = aws_iam_role.giantswarm.name
    policy_arn = aws_iam_policy.giantswarm-policy.arn
}
### END Admin Staff Role ###

resource "aws_iam_role" "giantswarm-staff" {
  name = "GiantSwarmAdmin"
  assume_role_policy = data.aws_iam_policy_document.giantswarm-staff.json
}

data "aws_iam_policy_document" "giantswarm-staff" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.principal_arns_giantswarm_staff
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "giantswarm-staff" {
  name   = "GiantSwarmAdminPolicy"
  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "giantswarm-staff" {
    role       = aws_iam_role.giantswarm-staff.name
    policy_arn = aws_iam_policy.giantswarm-staff.arn
}
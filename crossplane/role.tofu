locals {
  tags = {
    "installation" = var.installation_name
    "source"       = "https://github.com/giantswarm/giantswarm-aws-account-prerequisites/tree/main/crossplane"
  }

  principal_arn = "arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:user/${var.installation_name}-crossplane"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "giantswarm_crossplane_role" {
  name = "giantswarm-${var.installation_name}-crossplane"
  assume_role_policy = templatefile("${path.module}/policies/trusted-entities.json", {
    PRINCIPAL_ARN                    = local.principal_arn
    AWS_ACCOUNT_ID                   = data.aws_caller_identity.current.account_id
    AWS_PARTITION                    = data.aws_partition.current.partition
  })
  tags        = local.tags
  description = "Giant Swarm managed role for Crossplane"
}

resource "aws_iam_policy" "giantswarm_crossplane_policy" {
  name        = "giantswarm-${var.installation_name}-crossplane"
  policy      = file("${path.module}/policies/crossplane-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for Crossplane"
}
resource "aws_iam_role_policy_attachment" "giantswarm_crossplane_policy_attachment" {
  role       = aws_iam_role.giantswarm_crossplane_role.name
  policy_arn = aws_iam_policy.giantswarm_crossplane_policy.arn
}

// Ensure exclusivity of attached policies and inline policies

resource "aws_iam_role_policy_attachments_exclusive" "exclusive_policy_attachments" {
  role_name = aws_iam_role.giantswarm_crossplane_role.name
  policy_arns = [
    aws_iam_policy.giantswarm_crossplane_policy.arn
  ]
}

resource "aws_iam_role_policies_exclusive" "exclusive_inline_policies" {
  role_name    = aws_iam_role.giantswarm_crossplane_role.name
  policy_names = []
}

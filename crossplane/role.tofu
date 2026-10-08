locals {
  tags = {
    "installation" = var.installation_name
    "source"       = "https://github.com/giantswarm/giantswarm-aws-account-prerequisites/tree/main/crossplane"
  }

  principal_arn = "arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:user/${var.installation_name}-crossplane"
}

data "aws_partition" "current" {}

resource "aws_iam_role" "giantswarm_crossplane_role" {
  name = "giantswarm-${var.installation_name}-crossplane"
  assume_role_policy = templatefile("${path.module}/policies/trusted-entities.json", {
    PRINCIPAL_ARN = local.principal_arn
  })
  tags        = local.tags
  description = "Giant Swarm managed role for Crossplane"
}

# Former managed policy, no longer attached. Remove it in a follow-up release
# once `exclusive_policy_attachments` detached it in all accounts, since
# OpenTofu would otherwise try to delete it before detaching it.
resource "aws_iam_policy" "giantswarm_crossplane_policy" {
  name        = "giantswarm-${var.installation_name}-crossplane"
  policy      = file("${path.module}/policies/crossplane-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for Crossplane"
}

resource "aws_iam_role_policy" "giantswarm_crossplane" {
  name   = "giantswarm-${var.installation_name}-crossplane"
  role   = aws_iam_role.giantswarm_crossplane_role.name
  policy = file("${path.module}/policies/crossplane-policy.json")
}

# Leave detaching to `exclusive_policy_attachments` so that it happens only once
# the inline policy grants access
removed {
  from = aws_iam_role_policy_attachment.giantswarm_crossplane_policy_attachment

  lifecycle {
    destroy = false
  }
}

resource "aws_iam_role_policy" "additional_inline_policies" {
  for_each = var.additional_policies
  name     = each.key
  role     = aws_iam_role.giantswarm_crossplane_role.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachments" {
  for_each   = toset(var.additional_policies_arns)
  role       = aws_iam_role.giantswarm_crossplane_role.name
  policy_arn = each.value
}

// Ensure exclusivity of attached policies and inline policies

resource "aws_iam_role_policy_attachments_exclusive" "exclusive_policy_attachments" {
  role_name   = aws_iam_role.giantswarm_crossplane_role.name
  policy_arns = var.additional_policies_arns

  # Detach the former managed policy only once the inline policy grants access
  depends_on = [aws_iam_role_policy.giantswarm_crossplane]
}

resource "aws_iam_role_policies_exclusive" "exclusive_inline_policies" {
  role_name    = aws_iam_role.giantswarm_crossplane_role.name
  policy_names = concat([aws_iam_role_policy.giantswarm_crossplane.name], keys(var.additional_policies))
}

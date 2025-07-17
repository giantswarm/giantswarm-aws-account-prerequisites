data "aws_partition" "current" {}

data "aws_iam_policy_document" "giantswarm_admin" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "acm:*",
      "autoscaling:*",
      "cloudformation:*",
      "cloudfront:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "dynamodb:*",
      "ec2:*",
      "ecr:*",
      "elasticfilesystem:*",
      "elasticloadbalancing:*",
      "events:*",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateAccessKey",
      "iam:CreateInstanceProfile",
      "iam:CreateOpenIDConnectProvider",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteAccessKey",
      "iam:DeleteInstanceProfile",
      "iam:DeleteOpenIDConnectProvider",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteServiceLinkedRole",
      "iam:DetachRolePolicy",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:Get*",
      "iam:List*",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:TagOpenIDConnectProvider",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UntagInstanceProfile",
      "iam:UntagOpenIDConnectProvider",
      "iam:UntagPolicy",
      "iam:UntagRole",
      "iam:UpdateAccessKey",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:UpdateRoleDescription",
      "kms:*",
      "logs:*",
      "ram:*",
      "route53:*",
      "route53domains:*",
      "route53resolver:*",
      "s3:*",
      "sqs:*",
      "sts:AssumeRole",
      "sts:DecodeAuthorizationMessage",
      "sts:GetFederationToken",
      "support:*",
      "trustedadvisor:*",
    ]
  }
}

data "aws_iam_policy_document" "giantswarm_admin_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "giantswarm_admin" {
  name               = "GiantSwarmAdmin"
  assume_role_policy = data.aws_iam_policy_document.giantswarm_admin_assume.json

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

resource "aws_iam_policy" "giantswarm_admin_policy" {
  name   = "GiantSwarmAdmin"
  policy = data.aws_iam_policy_document.giantswarm_admin.json

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

resource "aws_iam_role_policy_attachment" "giantswarm_policy_attachment" {
  role       = aws_iam_role.giantswarm_admin.name
  policy_arn = aws_iam_policy.giantswarm_admin_policy.arn

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy" "additional_inline_policies" {
  for_each = var.additional_policies
  name     = each.key
  role     = aws_iam_role.giantswarm_admin.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachments" {
  for_each   = toset(var.additional_policies_arns)
  role       = aws_iam_role.giantswarm_admin.name
  policy_arn = each.value
}

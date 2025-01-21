terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

variable "gs_user_account" {
  type        = string
  description = "Account of Giant Swarm IAM users (`084190472784`, except for China)"
  default     = "084190472784"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.gs_user_account))
    error_message = "AWS account ID must consist of exactly 12 digits"
  }
}

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
      "directconnect:*", # @TODO: https://github.com/giantswarm/giantswarm/issues/32452
      "dynamodb:*",
      "ec2:*",
      "ecr:*",
      "elasticfilesystem:*",
      "elasticloadbalancing:*",
      "events:*",
      "ram:*",
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateAccessKey",
      "iam:CreateInstanceProfile",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteAccessKey",
      "iam:DeleteInstanceProfile",
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
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UpdateAccessKey",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRoleDescription",
      "kms:*",
      "logs:*",
      "route53:*",
      "route53domains:*",
      "route53resolver:*",
      "s3:*",
      "sts:AssumeRole",
      "sts:DecodeAuthorizationMessage",
      "sts:GetFederationToken",
      "support:*",
      "trustedadvisor:*",
      "sqs:*",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:RemoveClientIDFromOpenIDConnectProvider",
      "iam:AddClientIDToOpenIDConnectProvider"
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
}

resource "aws_iam_policy" "giantswarm_admin_policy" {
  name   = "GiantSwarmAdmin"
  policy = data.aws_iam_policy_document.giantswarm_admin.json
}

resource "aws_iam_role_policy_attachment" "giantswarm_policy_attachment" {
  role       = aws_iam_role.giantswarm_admin.name
  policy_arn = aws_iam_policy.giantswarm_admin_policy.arn
}

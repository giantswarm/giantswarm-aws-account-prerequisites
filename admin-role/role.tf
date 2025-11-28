data "aws_partition" "current" {}

data "aws_iam_policy_document" "giantswarm_admin" {
  # Allow all other non-EC2 services
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "acm:*",
      "autoscaling:*",
      "cloudfront:*",
      "cloudtrail:*",
      "cloudwatch:*",
      "ecr:*",
      "eks:*",
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

      # Service Quotas
      "servicequotas:GetAWSDefaultServiceQuota",
      "servicequotas:GetRequestedServiceQuotaChange",
      "servicequotas:GetServiceQuota",
      "servicequotas:ListAWSDefaultServiceQuotas",
      "servicequotas:ListRequestedServiceQuotaChangeHistory",
      "servicequotas:ListRequestedServiceQuotaChangeHistoryByQuota",
      "servicequotas:ListServiceQuotas",
      "servicequotas:ListServices",
      "servicequotas:ListTagsForResource",
      "servicequotas:RequestServiceQuotaIncrease",
      "servicequotas:TagResource",
      "servicequotas:UntagResource",

      # Grant read-only access to the following services
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:List*",
      "cloudformation:Validate*",
      "cloudformation:Estimate*",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchGet*",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:Verify*",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]
  }

  # Allow all EC2 actions
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:*"]
  }

  # Deny write/modify VPC-related EC2 actions when byovpc is true
  dynamic "statement" {
    for_each = var.byovpc ? [1] : []
    content {
      effect    = "Deny"
      resources = ["*"]
      actions = [
        "ec2:AcceptVpcEndpointConnections",
        "ec2:AcceptVpcPeeringConnection",
        "ec2:AssociateRouteTable",
        "ec2:AttachInternetGateway",
        "ec2:AttachVpnGateway",
        "ec2:CreateCustomerGateway",
        "ec2:CreateEgressOnlyInternetGateway",
        "ec2:CreateFlowLogs",
        "ec2:CreateInternetGateway",
        "ec2:CreateNatGateway",
        "ec2:CreateNetworkAcl",
        "ec2:CreateNetworkAclEntry",
        "ec2:CreateRoute",
        "ec2:CreateRouteTable",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSubnet",
        "ec2:CreateVpc",
        "ec2:CreateVpcEndpoint",
        "ec2:CreateVpcEndpointConnection",
        "ec2:CreateVpcEndpointConnectionNotification",
        "ec2:CreateVpcEndpointService",
        "ec2:CreateVpcEndpointServiceConfiguration",
        "ec2:CreateVpcEndpointServicePermissions",
        "ec2:CreateVpcPeeringConnection",
        "ec2:CreateVpnConnection",
        "ec2:CreateVpnGateway",
        "ec2:DeleteCustomerGateway",
        "ec2:DeleteEgressOnlyInternetGateway",
        "ec2:DeleteFlowLogs",
        "ec2:DeleteInternetGateway",
        "ec2:DeleteNatGateway",
        "ec2:DeleteNetworkAcl",
        "ec2:DeleteNetworkAclEntry",
        "ec2:DeleteRoute",
        "ec2:DeleteRouteTable",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteVpc",
        "ec2:DeleteVpcEndpointConnections",
        "ec2:DeleteVpcEndpointConnectionNotifications",
        "ec2:DeleteVpcEndpointService",
        "ec2:DeleteVpcEndpointServiceConfigurations",
        "ec2:DeleteVpcEndpointServicePermissions",
        "ec2:DeleteVpcEndpoints",
        "ec2:DeleteVpcPeeringConnection",
        "ec2:DeleteVpnConnection",
        "ec2:DeleteVpnGateway",
        "ec2:DetachInternetGateway",
        "ec2:DetachVpnGateway",
        "ec2:DisassociateRouteTable",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:ModifySubnetAttribute",
        "ec2:ModifyVpcAttribute",
        "ec2:ModifyVpcEndpoint",
        "ec2:ModifyVpcEndpointService",
        "ec2:ModifyVpcEndpointServiceConfiguration",
        "ec2:ModifyVpcEndpointServicePermissions",
        "ec2:RejectVpcEndpointConnections",
        "ec2:RejectVpcPeeringConnection",
        "ec2:ReplaceNetworkAclAssociation",
        "ec2:ReplaceNetworkAclEntry",
        "ec2:ReplaceRoute",
        "ec2:ReplaceRouteTableAssociation",
      ]
    }
  }

  # Deny deletion actions for CloudTrail, ECR, and CloudWatch
  statement {
    effect    = "Deny"
    resources = ["*"]
    actions = [
      # CloudTrail deletion actions
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:PutEventSelectors",
      "cloudtrail:PutInsightSelectors",

      # ECR deletion actions
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:BatchDeleteImage",
      "ecr:DeleteLifecyclePolicy",
      "ecr:DeleteRegistryPolicy",
      "ecr:DeletePullThroughCacheRule",

      # CloudWatch deletion actions
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DeleteAnomalyDetector",
      "cloudwatch:DeleteDashboards",
      "cloudwatch:DeleteInsightRules",
      "cloudwatch:DeleteMetricFilter",
      "cloudwatch:DeleteMetricStream",
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
  }
}

resource "aws_iam_policy" "giantswarm_admin_policy" {
  name   = "GiantSwarmAdmin"
  policy = data.aws_iam_policy_document.giantswarm_admin.json

  lifecycle {
    prevent_destroy = true
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

// Ensure exclusivity of attached policies and inline policies

resource "aws_iam_role_policy_attachments_exclusive" "exclusive_policy_attachments" {
  role_name   = aws_iam_role.giantswarm_admin.name
  policy_arns = concat([aws_iam_policy.giantswarm_admin_policy.arn], var.additional_policies_arns)
}

resource "aws_iam_role_policies_exclusive" "exclusive_inline_policies" {
  role_name    = aws_iam_role.giantswarm_admin.name
  policy_names = keys(var.additional_policies)
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "giantswarm_agent_read_only" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    # An agent may enumerate and describe resources, but generally not read what
    # they contain.

    actions = [
      # ACM
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",

      # Auto Scaling
      "autoscaling:Describe*",
      "autoscaling:Get*",

      # CloudFormation
      "cloudformation:Describe*",
      "cloudformation:Get*",
      "cloudformation:List*",
      "cloudformation:ValidateTemplate",

      # CloudFront
      "cloudfront:Get*",
      "cloudfront:List*",
      "cloudfront:VerifyDnsConfiguration",

      # CloudTrail
      "cloudtrail:Describe*",
      "cloudtrail:Get*",
      "cloudtrail:List*",
      "cloudtrail:LookupEvents",

      # CloudWatch
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",

      # Cost Explorer
      "ce:DescribeCostCategoryDefinition",
      "ce:GetAnomalies",
      "ce:GetCostAndUsage",
      "ce:GetCostAndUsageComparisons",
      "ce:GetCostAndUsageWithResources",
      "ce:GetCostCategories",
      "ce:GetCostComparisonDrivers",
      "ce:GetCostForecast",
      "ce:GetDimensionValues",
      "ce:GetReservationCoverage",
      "ce:GetReservationUtilization",
      "ce:GetSavingsPlansCoverage",
      "ce:GetSavingsPlansUtilization",
      "ce:GetTags",
      "ce:GetUsageForecast",
      "ce:ListCostAllocationTags",

      # DynamoDB
      "dynamodb:Describe*",
      "dynamodb:List*",

      # EC2
      "ec2:Describe*",
      "ec2:Get*",
      "ec2:List*",

      # ECR
      "ecr:BatchCheck*",
      "ecr:Describe*",
      "ecr:List*",

      # EFS
      "elasticfilesystem:Describe*",
      "elasticfilesystem:List*",

      # EKS (Elastic Kubernetes Service)
      "eks:Describe*",
      "eks:List*",

      # Elastic Load Balancing
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:Get*",

      # EventBridge
      "events:Describe*",
      "events:List*",

      # IAM
      "iam:Get*",
      "iam:List*",

      # KMS
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",

      # CloudWatch Logs
      "logs:Describe*",
      "logs:Get*",
      "logs:List*",
      "logs:FilterLogEvents",

      # RAM
      "ram:Get*",
      "ram:List*",

      # Route53
      "route53:Get*",
      "route53:List*",

      # Route53 Domains
      "route53domains:Get*",
      "route53domains:List*",

      # Route53 Resolver
      "route53resolver:Get*",
      "route53resolver:List*",

      # S3
      #
      # Enumerated rather than `s3:Get*`, which would include bucket contents.
      "s3:GetAccountPublicAccessBlock",
      "s3:GetBucket*",
      "s3:GetEncryptionConfiguration",
      "s3:List*",

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

      # SQS
      "sqs:Get*",
      "sqs:List*",

      # STS
      "sts:DecodeAuthorizationMessage",
      "sts:GetCallerIdentity",

      # Trusted Advisor
      "trustedadvisor:Describe*",
      "trustedadvisor:Get*",
      "trustedadvisor:List*"
    ]
  }

  statement {
    effect    = "Deny"
    resources = ["*"]

    # Actions that read resource contents rather than resource metadata, and
    # that the `Describe*` / `Get*` wildcards above would otherwise grant.

    actions = [
      # DynamoDB
      #
      # Table items.
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PartiQLSelect",
      "dynamodb:Query",
      "dynamodb:Scan",

      # EC2
      #
      # Instance user data, boot logs, a screenshot of a live console session,
      # and the encrypted Windows administrator password.
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetConsoleOutput",
      "ec2:GetConsoleScreenshot",
      "ec2:GetLaunchTemplateData",
      "ec2:GetPasswordData",

      # ECR
      #
      # Image contents, and a registry credential.
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",

      # S3
      #
      # Bucket contents, including old versions.
      "s3:GetObject",
      "s3:GetObjectVersion",

      # STS
      #
      # A portable credential that outlives the request.
      "sts:GetFederationToken"
    ]
  }
}

data "aws_iam_policy_document" "giantswarm_agent_read_only_assume" {
  # Only the agent access role in the Giant Swarm root account may assume this
  # role. Agents authenticate once against that role, then chain into every
  # account from there.

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:role/GiantSwarmAgentAccessReadOnly"]
    }

    # `sts:SetSourceIdentity` is used to allow passing a session description in the role chain
    # so that audit logs (CloudTrail) show it.
    actions = ["sts:AssumeRole", "sts:SetSourceIdentity"]
  }
}

resource "aws_iam_role" "giantswarm_agent_read_only" {
  name               = "GiantSwarmAgentReadOnly"
  assume_role_policy = data.aws_iam_policy_document.giantswarm_agent_read_only_assume.json
}

resource "aws_iam_policy" "giantswarm_agent_read_only" {
  name   = "GiantSwarmAgentReadOnly"
  policy = data.aws_iam_policy_document.giantswarm_agent_read_only.minified_json
}

resource "aws_iam_role_policy_attachment" "giantswarm_agent_read_only" {
  role       = aws_iam_role.giantswarm_agent_read_only.name
  policy_arn = aws_iam_policy.giantswarm_agent_read_only.arn
}

resource "aws_iam_role_policy" "additional" {
  for_each = var.additional_policies
  name     = each.key
  role     = aws_iam_role.giantswarm_agent_read_only.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = toset(var.additional_policies_arns)
  role       = aws_iam_role.giantswarm_agent_read_only.name
  policy_arn = each.value
}


// Ensure exclusivity of attached policies and inline policies

resource "aws_iam_role_policy_attachments_exclusive" "exclusive_policy_attachments" {
  role_name   = aws_iam_role.giantswarm_agent_read_only.name
  policy_arns = concat([aws_iam_policy.giantswarm_agent_read_only.arn], var.additional_policies_arns)
}

resource "aws_iam_role_policies_exclusive" "exclusive_inline_policies" {
  role_name    = aws_iam_role.giantswarm_agent_read_only.name
  policy_names = keys(var.additional_policies)
}

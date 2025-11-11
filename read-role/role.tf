data "aws_partition" "current" {}

data "aws_iam_policy_document" "giantswarm_read_only" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      # ACM - Certificate Manager
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

      # DynamoDB
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",

      # EC2
      "ec2:Describe*",
      "ec2:Get*",
      "ec2:List*",

      # ECR
      "ecr:BatchCheck*",
      "ecr:BatchGet*",
      "ecr:Describe*",
      "ecr:Get*",
      "ecr:List*",

      # EFS (Elastic File System)
      "elasticfilesystem:Describe*",
      "elasticfilesystem:List*",

      # EKS (Elastic Kubernetes Service)
      "eks:Describe*",
      "eks:Get*",
      "eks:List*",

      # Elastic Load Balancing
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:Get*",

      # EventBridge
      "events:Describe*",
      "events:List*",

      # IAM - Read-only actions only
      "iam:Get*",
      "iam:List*",
      "iam:GenerateServiceLastAccessedDetails",

      # KMS
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",

      # CloudWatch Logs
      "logs:Describe*",
      "logs:Get*",
      "logs:List*",
      "logs:FilterLogEvents",

      # RAM (Resource Access Manager)
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
      "s3:Get*",
      "s3:List*",

      # SQS
      "sqs:Get*",
      "sqs:List*",

      # STS - Read-only actions only
      "sts:DecodeAuthorizationMessage",
      "sts:GetCallerIdentity",
      "sts:GetFederationToken",

      # Trusted Advisor
      "trustedadvisor:Describe*",
      "trustedadvisor:Get*",
      "trustedadvisor:List*"
    ]
  }
}

data "aws_iam_policy_document" "giantswarm_read_only_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "giantswarm_read_only" {
  name               = "GiantSwarmReadOnly"
  assume_role_policy = data.aws_iam_policy_document.giantswarm_read_only_assume.json
}

resource "aws_iam_policy" "giantswarm_read_only" {
  name   = "GiantSwarmReadOnly"
  policy = data.aws_iam_policy_document.giantswarm_read_only.minified_json
}

resource "aws_iam_role_policy_attachment" "giantswarm_read_only" {
  role       = aws_iam_role.giantswarm_read_only.name
  policy_arn = aws_iam_policy.giantswarm_read_only.arn
}

resource "aws_iam_role_policy" "additional" {
  for_each = var.additional_policies
  name     = each.key
  role     = aws_iam_role.giantswarm_read_only.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = toset(var.additional_policies_arns)
  role       = aws_iam_role.giantswarm_read_only.name
  policy_arn = each.value
}


// Ensure exclusivity of attached policies and inline policies

resource "aws_iam_role_policy_attachments_exclusive" "exclusive_policy_attachments" {
  role_name   = aws_iam_role.giantswarm_read_only.name
  policy_arns = concat([aws_iam_policy.giantswarm_read_only.arn], var.additional_policies_arns)
}

resource "aws_iam_role_policies_exclusive" "exclusive_inline_policies" {
  role_name    = aws_iam_role.giantswarm_read_only.name
  policy_names = keys(var.additional_policies)
}

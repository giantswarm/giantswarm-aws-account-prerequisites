locals {
  tags = {
    "installation" = var.installation_name
  }
}

provider "aws" {
  ignore_tags {
    keys = ["maintainer", "owner", "repo"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "giantswarm-capa-controller-role" {
  name               = "giantswarm-${var.installation_name}-capa-controller"
  assume_role_policy = templatefile("${path.module}/trusted-entities.json", {
    INSTALLATION_NAME                       = var.installation_name
    AWS_ACCOUNT_ID                          = data.aws_caller_identity.current.account_id
    MANAGEMENT_CLUSTER_OIDC_PROVIDER_DOMAIN = var.management_cluster_oidc_provider_domain
  })
  tags = local.tags
}

resource "aws_iam_policy" "giantswarm-capa-controller-policy" {
  name   = "giantswarm-${var.installation_name}-capa-controller-policy"
  policy = file("${path.module}/capa-controller-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-capa-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-capa-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-capa-controller-policy-vpc" {
  count  = var.byovpc ? 0 : 1 # This policy is not needed in BYO VPC installations
  name   = "giantswarm-${var.installation_name}-capa-controller-policy-vpc"
  policy = file("${path.module}/capa-controller-policy-vpc.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-capa-controller-policy-vpc-attachment" {
  count      = var.byovpc ? 0 : 1 # This policy is not needed in BYO VPC installations
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-capa-controller-policy-vpc[0].arn
}

resource "aws_iam_policy" "giantswarm-dns-controller-policy" {
  name   = "giantswarm-${var.installation_name}-dns-controller-policy"
  policy = file("${path.module}/dns-controller-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-dns-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-dns-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-eks-controller-policy" {
  name   = "giantswarm-${var.installation_name}-eks-controller-policy"
  policy = file("${path.module}/eks-controller-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-eks-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-eks-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-iam-controller-policy" {
  name   = "giantswarm-${var.installation_name}-iam-controller-policy"
  policy = file("${path.module}/iam-controller-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-iam-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-iam-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-irsa-controller-policy" {
  name   = "giantswarm-${var.installation_name}-irsa-controller-policy"
  policy = file("${path.module}/irsa-operator-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-irsa-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-irsa-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-network-topology-controller-policy" {
  name   = "giantswarm-${var.installation_name}-network-topology-controller-policy"
  policy = file("${path.module}/network-topology-operator-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-network-topology-controller-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-network-topology-controller-policy.arn
}

resource "aws_iam_policy" "giantswarm-resolver-rules-operator-policy" {
  name   = "giantswarm-${var.installation_name}-resolver-rules-operator-policy"
  policy = file("${path.module}/resolver-rules-operator-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-resolver-rules-operator-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-resolver-rules-operator-policy.arn
}

resource "aws_iam_policy" "giantswarm-mc-bootstrap-policy" {
  name   = "giantswarm-${var.installation_name}-mc-bootstrap-policy"
  policy = file("${path.module}/mc-bootstrap-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-mc-bootstrap-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-mc-bootstrap-policy.arn
}

resource "aws_iam_policy" "giantswarm-crossplane-policy" {
  name   = "giantswarm-${var.installation_name}-crossplane-policy"
  policy = file("${path.module}/crossplane-policy.json")
  tags   = local.tags
}
resource "aws_iam_role_policy_attachment" "giantswarm-crossplane-policy-attachment" {
  role       = aws_iam_role.giantswarm-capa-controller-role.name
  policy_arn = aws_iam_policy.giantswarm-crossplane-policy.arn
}

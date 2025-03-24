locals {
  tags = {
    "installation" = var.installation_name
  }

  principal_arn = coalesce(var.principal_arn_override, "arn:${data.aws_partition.current.partition}:iam::${var.gs_user_account}:user/${var.installation_name}-capa-controller")
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "giantswarm_capa_controller_role" {
  name = "giantswarm-${var.installation_name}-capa-controller"
  assume_role_policy = templatefile("${path.module}/policies/trusted-entities.json", {
    PRINCIPAL_ARN                    = local.principal_arn
    AWS_ACCOUNT_ID                   = data.aws_caller_identity.current.account_id
    MANAGEMENT_CLUSTER_OIDC_PROVIDER = var.management_cluster_oidc_provider
    AWS_PARTITION                    = data.aws_partition.current.partition
  })
  tags        = local.tags
  description = "Giant Swarm managed role for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}

resource "aws_iam_policy" "giantswarm_capa_controller_policy" {
  name        = "giantswarm-${var.installation_name}-capa-controller-policy"
  policy      = file("${path.module}/policies/capa-controller-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_capa_controller_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_capa_controller_policy.arn
}

resource "aws_iam_policy" "giantswarm_capa_controller_vpc_policy" {
  count       = var.byovpc ? 0 : 1 # This policy is not needed in BYO VPC installations
  name        = "giantswarm-${var.installation_name}-capa-controller-vpc-policy"
  policy      = file("${path.module}/policies/capa-controller-vpc-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_capa_controller_vpc_policy_attachment" {
  count      = var.byovpc ? 0 : 1 # This policy is not needed in BYO VPC installations
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_capa_controller_vpc_policy[0].arn
}

resource "aws_iam_policy" "giantswarm_dns_controller_policy" {
  name        = "giantswarm-${var.installation_name}-dns-controller-policy"
  policy      = file("${path.module}/policies/dns-controller-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_dns_controller_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_dns_controller_policy.arn
}

resource "aws_iam_policy" "giantswarm_eks_controller_policy" {
  count       = var.eks ? 1 : 0 # This policy is only needed in installations that require EKS support
  name        = "giantswarm-${var.installation_name}-eks-controller-policy"
  policy      = file("${path.module}/policies/eks-controller-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_eks_controller_policy_attachment" {
  count      = var.eks ? 1 : 0 # This policy is only needed in installations that require EKS support
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_eks_controller_policy[count.index].arn
}

resource "aws_iam_policy" "giantswarm_iam_controller_policy" {
  name        = "giantswarm-${var.installation_name}-iam-controller-policy"
  policy      = file("${path.module}/policies/iam-controller-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_iam_controller_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_iam_controller_policy.arn
}

resource "aws_iam_policy" "giantswarm_irsa_controller_policy" {
  name        = "giantswarm-${var.installation_name}-irsa-controller-policy"
  policy      = file("${path.module}/policies/irsa-operator-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_irsa_controller_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_irsa_controller_policy.arn
}

resource "aws_iam_policy" "giantswarm_network_topology_controller_policy" {
  name        = "giantswarm-${var.installation_name}-network-topology-controller-policy"
  policy      = file("${path.module}/policies/network-topology-operator-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_network_topology_controller_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_network_topology_controller_policy.arn
}

resource "aws_iam_policy" "giantswarm_resolver_rules_operator_policy" {
  count       = var.resolverrules ? 1 : 0 # This policy is only needed in installations that require route53 resolver rules support
  name        = "giantswarm-${var.installation_name}-resolver-rules-operator-policy"
  policy      = file("${path.module}/policies/resolver-rules-operator-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_resolver_rules_operator_policy_attachment" {
  count      = var.resolverrules ? 1 : 0 # This policy is only needed in installations that require route53 resolver rules support
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_resolver_rules_operator_policy[count.index].arn
}

resource "aws_iam_policy" "giantswarm_mc_bootstrap_policy" {
  name        = "giantswarm-${var.installation_name}-mc-bootstrap-policy"
  policy      = file("${path.module}/policies/mc-bootstrap-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_mc_bootstrap_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_mc_bootstrap_policy.arn
}

resource "aws_iam_policy" "giantswarm_crossplane_policy" {
  name        = "giantswarm-${var.installation_name}-crossplane-policy"
  policy      = file("${path.module}/policies/crossplane-policy.json")
  tags        = local.tags
  description = "Giant Swarm managed policy for k8s cluster creation"
  lifecycle {
    # Avoid recreation due to these fields in case the object was initially created with different values
    ignore_changes = [description]
  }
}
resource "aws_iam_role_policy_attachment" "giantswarm_crossplane_policy_attachment" {
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = aws_iam_policy.giantswarm_crossplane_policy.arn
}

resource "aws_iam_role_policy" "additional_inline_policies" {
  for_each = var.additional_policies
  name     = each.key
  role     = aws_iam_role.giantswarm_capa_controller_role.name
  policy   = each.value
}

resource "aws_iam_role_policy_attachment" "additional_policy_attachments" {
  for_each   = toset(var.additional_policies_arns)
  role       = aws_iam_role.giantswarm_capa_controller_role.name
  policy_arn = each.value
}

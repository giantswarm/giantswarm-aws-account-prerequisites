import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role.giantswarm_capa_controller_role
  id       = "giantswarm-${each.value.name}-capa-controller"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_capa_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-capa-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_capa_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-capa-controller-policy"
}

import {
  for_each = local.mc_account_map_no_byovpc
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_capa_controller_vpc_policy[0]
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-capa-controller-vpc-policy"
}

import {
  for_each = local.mc_account_map_no_byovpc
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_capa_controller_vpc_policy_attachment[0]
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-capa-controller-vpc-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_dns_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-dns-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_dns_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-dns-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_eks_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-eks-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_eks_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-eks-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_iam_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-iam-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_iam_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-iam-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_irsa_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-irsa-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_irsa_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-irsa-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_network_topology_controller_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-network-topology-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_network_topology_controller_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-network-topology-controller-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_resolver_rules_operator_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-resolver-rules-operator-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_resolver_rules_operator_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-resolver-rules-operator-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_mc_bootstrap_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-mc-bootstrap-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_mc_bootstrap_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-mc-bootstrap-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_policy.giantswarm_crossplane_policy
  id       = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-crossplane-policy"
}

import {
  for_each = local.mc_account_map
  to       = module.capa_controller_role[each.key].aws_iam_role_policy_attachment.giantswarm_crossplane_policy_attachment
  id       = "giantswarm-${each.value.name}-capa-controller/arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:policy/giantswarm-${each.value.name}-crossplane-policy"
}

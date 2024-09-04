locals {
  existing_install_for_each = var.import_existing ? toset([1]) : toset([])
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role.giantswarm-capa-controller-role
  id = "giantswarm-${var.installation_name}-capa-controller"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-capa-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-capa-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-capa-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-capa-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-dns-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-dns-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-dns-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-dns-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-eks-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-eks-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-eks-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-eks-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-iam-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-iam-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-iam-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-iam-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-irsa-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-irsa-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-irsa-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-irsa-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-network-topology-controller-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-network-topology-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-network-topology-controller-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-network-topology-controller-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-resolver-rules-operator-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-resolver-rules-operator-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-resolver-rules-operator-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-resolver-rules-operator-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-mc-bootstrap-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-mc-bootstrap-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-mc-bootstrap-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-mc-bootstrap-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_policy.giantswarm-crossplane-policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-crossplane-policy"
}

import {
  for_each = local.existing_install_for_each
  to = aws_iam_role_policy_attachment.giantswarm-crossplane-policy-attachment
  id = "giantswarm-${var.installation_name}-capa-controller/arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/giantswarm-${var.installation_name}-crossplane-policy"
}

locals {
  mc_account_flat = flatten([
    for mc_name, mc in var.management_clusters : [
      for account in mc.aws_account : {
        name = mc_name
        aws_account = account
        oidc_provider_domain = mc.oidc_provider_domain
      }
    ]
  ])

  mc_account_map = {
    for i in local.mc_account_flat : "${i.name}-${i.aws_account.account_id}" => i
  }
}

provider "aws" {
  alias = "main"
  region = each.value.aws_account.region
  for_each = local.mc_account_map

  assume_role {
    role_arn = "arn:${each.value.aws_account.aws_partition}:iam::${each.value.aws_account.account_id}:role/GiantSwarmAdmin"
  }
}

module "capa_controller_role" {
  source = "../capa-controller-role"
  for_each = local.mc_account_map
  providers = {
    aws = aws.main[each.key]
  }

  installation_name = each.value.name
  management_cluster_oidc_provider_domain = each.value.oidc_provider_domain
  byovpc = each.value.aws_account.byovpc
  # gs_user_account = TODO

  # TBD
  # additional_policies = each.value.aws_account.additional_policies
  # additional_policies_arns = each.value.aws_account.additional_policies_arns
}

output "mc_account_setup" {
  value = {for k, v in module.mc_account_setup : k => v}
}

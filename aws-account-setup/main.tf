terraform {
  required_providers {
    aws = {
      source  = "opentofu/aws"
      version = "5.81.0"
    }
  }
}

locals {
  gs_user_accounts_map = {
    "aws" = "084190472784"
    "aws-cn" = "306934455918"
  }

  workspace_partition_map = {
    "default" = "aws"
    "china" = "aws-cn"
  }

  mc_account_flat = flatten([
    for mc_name, mc in var.management_clusters : [
      for account in mc.aws_account : {
        name = mc_name
        aws_account = account
        oidc_provider_domain = mc.oidc_provider_domain
      } if local.workspace_partition_map[terraform.workspace] == account.aws_partition
    ]
  ])

  mc_account_map = {
    for i in local.mc_account_flat : "${i.name}-${i.aws_account.account_id}" => i
  }

  mc_account_map_no_byovpc = {
    for i in local.mc_account_flat : "${i.name}-${i.aws_account.account_id}" => i if !i.aws_account.byovpc
  }

  aws_account_list = distinct([
    for mc in local.mc_account_flat : {
      account_id = mc.aws_account.account_id
      aws_partition = mc.aws_account.aws_partition
    }
  ])

  aws_account_map = {
    for account in local.aws_account_list : account.account_id => account.aws_partition
  }
}

provider "aws" {
  alias = "main"
  region = "eu-west-1" # Irrelevant as we are only creating IAM stuff
  for_each = local.aws_account_map
  profile = each.value == "aws" ? var.aws_profile : var.aws_cn_profile

  assume_role {
    role_arn = "arn:${each.value}:iam::${each.key}:role/GiantSwarmAdmin"
  }

  allowed_account_ids = [each.key]

  ignore_tags {
    keys = ["maintainer", "owner", "repo"]
  }
}

# module "gs_admin_role" {
#   source = "../admin-role"
#   for_each = local.aws_account_map
#   providers = {
#     aws = aws.main[each.key]
#   }

#   gs_user_account = local.gs_user_accounts_map[each.value]
#   aws_partition = each.value
# }

module "capa_controller_role" {
  source = "../capa-controller-role"
  for_each = local.mc_account_map
  providers = {
    aws = aws.main[each.value.aws_account.account_id]
  }

  installation_name = each.value.name
  management_cluster_oidc_provider_domain = each.value.oidc_provider_domain
  byovpc = each.value.aws_account.byovpc
  gs_user_account = local.gs_user_accounts_map[each.value.aws_account.aws_partition]
  aws_partition = each.value.aws_account.aws_partition

  # TBD
  # additional_policies = each.value.aws_account.additional_policies
  # additional_policies_arns = each.value.aws_account.additional_policies_arns
}

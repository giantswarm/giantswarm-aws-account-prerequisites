variable "installation_name" {
  type        = string
  description = "Name of the installation (= name of management cluster). Please ask Giant Swarm staff to provide it."
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

variable "management_cluster_oidc_provider_domain" {
  type        = string
  description = "OIDC provider domain of the management cluster"

  validation {
    condition     = can(regex("^([0-9a-z-]+)(\\.[0-9a-z-]+)+$", var.management_cluster_oidc_provider_domain))
    error_message = "Invalid OIDC provider domain"
  }
}

variable "byovpc" {
  type        = bool
  description = "If true, the CAPA role will be created without the permissions needed to manage VPCs"
  default     = false
}

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

resource "aws_cloudformation_stack" "giantswarm_capa_controller" {
  name          = "CAPAControllerRoleBootstrap"
  template_body = file("${path.module}/cloud-formation-template.yaml")

  parameters = {
    InstallationName = var.installation_name

    ByoVpc                              = var.byovpc
    ManagementClusterOidcProviderDomain = var.management_cluster_oidc_provider_domain
    GiantSwarmUserAccount               = var.gs_user_account
  }

  tags = local.tags
}

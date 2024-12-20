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

variable "aws_partition" {
  type        = string
  description = "AWS partition (e.g. `aws` or `aws-cn`)"
  default     = "aws"
}

variable "import_existing" {
  type        = bool
  description = "If true, the existing role and policies will be imported instead of created"
  default     = false
}

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

variable "principal_arn_override" {
  type        = string
  description = "ARN of the principal that will assume the role. If omitted it will be inferred as 'arn:$${data.aws_partition.current.partition}:iam::$${var.gs_user_account}:user/$${var.installation_name}-capa-controller'."
  default     = null
}

variable "management_cluster_oidc_provider" {
  type        = string
  description = "OIDC provider name of the management cluster"

  validation {
    condition     = can(regex("^([0-9a-z-]+)(\\.[0-9a-z-]+)+(\\/[0-9a-z-]+)*$", var.management_cluster_oidc_provider))
    error_message = "Invalid OIDC provider name"
  }
}

variable "byovpc" {
  type        = bool
  description = "If true, the CAPA role will be created without the permissions needed to manage VPCs"
  default     = false
}

variable "eks" {
  type        = bool
  description = "If true, the CAPA role will be created with the permissions needed to manage EKS clusters"
  default     = false
}

variable "additional_policies" {
  type        = map(string)
  description = "Map of additional policy documents to attach to the IAM role"
  default     = {}
}

variable "additional_policies_arns" {
  type        = list(string)
  description = "List of ARNs of additional managed policies to attach to the role"
  default     = []
}

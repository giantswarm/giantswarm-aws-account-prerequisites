variable "installation_name" {
  type        = string
  description = "If you dont know what `installation_name` value is suppose to be, ask Giant Swarm staff and they will provide it."
}

variable "aws_partition" {
  type        = string
  description = "AWS partition used for ARN referencing, use aws-cn for China regions"
  default     = "aws"
}

variable "management_cluster_oidc_provider_domain" {
  type        = string
  description = "OIDC provider domain of the management cluster"
}

variable "import_existing" {
  type        = bool
  description = "If true, import existing resources"
  default     = false
}

variable "byovpc" {
  type        = bool
  description = "If true, the CAPA role will be created without the permissions needed to manage VPCs"
  default     = false
}

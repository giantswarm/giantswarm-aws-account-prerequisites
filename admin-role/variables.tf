variable "gs_user_account" {
  type        = string
  description = "Account of Giant Swarm IAM users (`084190472784`, except for China)"
  default     = "084190472784"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.gs_user_account))
    error_message = "AWS account ID must consist of exactly 12 digits"
  }
}

variable "additional_policies" {
  type        = map(string)
  description = "Map of additional policy documents to attach to the IAM role"
  default     = {}
}

variable "additional_policies_arns" {
  type        = list(string)
  description = "List of ARNs of additional managed policies to attach to the IAM role"
  default     = []
}

variable "byovpc" {
  type        = bool
  description = "If true, the IAM role will be created without the permissions needed to manage VPCs"
  default     = false
}

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

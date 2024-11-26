variable "admin_role_name" {
  type    = string
  default = "GiantSwarmAdmin"
}

variable "gs_user_account" {
  type        = string
  description = "AWS account where GS staff users are located"
  default     = "084190472784"
}

variable "admin_role_name" {
  type    = string
  default = "GiantSwarmAdmin"
}

variable "aws_partition" {
  type        = string
  description = "AWS partition used for ARN referencing, use aws-cn for China regions"
  default     = "aws"
}

variable "gs_user_account" {
  type        = string
  description = "AWS account where GS staff users are located"
  default     = "084190472784"
}

variable "main_account_id" {
  type        = string
  description = "AWS account ID of the control plane account"
}

variable "tenant_account_id" {
  type        = string
  description = "AWS account ID of the tenant account"
}

variable "operator_role_name" {
  type    = string
  default = "GiantSwarmRoleAWSOperator"
}

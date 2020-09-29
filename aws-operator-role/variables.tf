variable "arn_prefix" {
  type        = string
  description = "AWS ARN prefix which is different for CN regions (arn:aws-cn)"
  default     = "arn:aws"
}

variable "main_account_id" {
  type        = string
  description = "AWS account ID of the control plane account"
}

variable "target_account_id" {
  type        = string
  description = "AWS account ID of the tenant or the control plane account"
}

variable "operator_role_name" {
  type    = string
  default = "GiantSwarmRoleAWSOperator"
}

variable "operator_user_name" {
  type        = string
  default     = "GiantSwarmAWSOperator"
  description = "Name of the aws-operator user which can assume the role"
}

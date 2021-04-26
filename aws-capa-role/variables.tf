variable "arn_prefix" {
  type        = string
  description = "AWS ARN prefix which is different for CN regions (arn:aws-cn)"
  default     = "arn:aws"
}

variable "main_account_id" {
  type        = string
  description = "AWS account ID of the management cluster account"
}

variable "target_account_id" {
  type        = string
  description = "AWS account ID of the workload cluster or the management cluster account"
}

variable "operator_user_name" {
  type        = string
  default     = "GiantSwarmAWSCapaController"
  description = "Name of the cluster-api-aws-controller user in the main account which can assume the role"
}

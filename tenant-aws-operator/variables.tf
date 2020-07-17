variable "main_account_id" {
  type        = string
  description = "AWS account ID of the control plane account"
}

variable "tenant_account_id" {
  type        = string
  description = "AWS account ID of the tenant account"
}

variable "principal_arns_giantswarm_staff" {
  type        = list(string)
  description = "ARNs of accounts, groups, or users with the ability to assume this role."
  default =["arn:aws:iam::084190472784:root"]
}

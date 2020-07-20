variable "principal_arns_giantswarm_root_account" {
  type        = list(string)
  description = "ARNs of accounts, groups, or users with the ability to assume this role."
  default =["arn:aws:iam::084190472784:root"]
}

variable "admin_role_name" {
  type    = string
  default = "GiantSwarmAdmin"
}

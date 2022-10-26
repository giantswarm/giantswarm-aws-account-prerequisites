variable "principal_arns_giantswarm_root_account" {
  type        = list(string)
  description = "ARNs of accounts, groups, or users with the ability to assume this role."
  # if you know installation name you can restrict this to 'arn:aws:iam::084190472784:user/${INSTALLATION_NAME}-capa-controller'
  default =["arn:aws:iam::084190472784:root"]
}

variable "capa_controller_role_name" {
  type    = string
  default = "giantswarm-capa-controller"
}

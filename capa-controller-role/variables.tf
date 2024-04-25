variable "principal_arns_giantswarm_root_account" {
  type        = list(string)
  description = "ARNs of accounts, groups, or users with the ability to assume this role."
  # if you know installation name you can restrict this to 'arn:aws:iam::084190472784:user/${INSTALLATION_NAME}-capa-controller'
  default = ["arn:aws:iam::084190472784:root"]
}

variable "installation_name" {
  type        = string
  description = "If you dont know what `installation_name` value is suppose to be, ask Giant Swarm staff and they will provide it."
}

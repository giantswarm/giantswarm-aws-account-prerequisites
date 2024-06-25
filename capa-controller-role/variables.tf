variable "management_cluster_account_id" {
  type        = string
  description = "AWS account ID of the management cluster"
}

variable "installation_name" {
  type        = string
  description = "If you dont know what `installation_name` value is suppose to be, ask Giant Swarm staff and they will provide it."
}

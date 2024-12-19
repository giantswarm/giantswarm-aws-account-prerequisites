variable "management_clusters" {
  type = map(object({
    aws_account = list(object({
      account_id = string
      aws_partition = string
      byovpc = bool
      additional_policies = list(string)
      additional_policies_arns = list(string)
    })),
    oidc_provider_domain = string
  }))
}

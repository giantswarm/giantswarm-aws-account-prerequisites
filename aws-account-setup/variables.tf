variable "management_clusters" {
  type = map(object({
    aws_account = list(object({
      account_id = string
      aws_partition = optional(string, "aws")
      byovpc = optional(bool, false)
      additional_policies = optional(list(string), [])
      additional_policies_arns = optional(list(string), [])
    })),
    oidc_provider_domain = string
  }))
}

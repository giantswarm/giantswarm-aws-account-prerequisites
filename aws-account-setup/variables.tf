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

  validation {
    condition = alltrue(flatten([for name, m in var.management_clusters : [for a in m.aws_account : can(regex("^aws(-cn)?$", a.aws_partition))]]))
    error_message = "The only AWS partitions supported are `aws` and `aws-cn`"
  }
}

variable "aws_profile" {
  type = string
  description = "AWS CLI profile to use for initializing the AWS provider. This profile will be used to assume the GiantSwarmAdmin IAM role in each account."
  default = "giantswarm"
}

variable "aws_cn_profile" {
  type = string
  description = "AWS CLI profile to use for initializing the AWS provider in the aws-cn (China) partition. This profile will be used to assume the GiantSwarmAdmin IAM role in each account."
  default = "giantswarm-cn"
}

locals {
  services = toset([for service, _ in var.service_quotas : service])

  service_quotas = merge([
    for service, quotas in var.service_quotas : {
      for quota, limit in quotas :
      "${service}/${quota}" => {
        service = service
        quota   = quota
        limit   = limit
      }
    }
  ]...)
}

# Look up the code of a service by its name.
data "aws_servicequotas_service" "this" {
  for_each = local.services

  service_name = each.value
}

# Look up the code of a quota by its name, and the code of the service
# that was looked up earlier.
data "aws_servicequotas_service_quota" "this" {
  for_each = local.service_quotas

  service_code = data.aws_servicequotas_service.this[each.value.service].service_code
  quota_name   = each.value.quota
}

# Request a service quota increase if the requested quota is higher than the current quota.
resource "aws_servicequotas_service_quota" "this" {
  for_each = local.service_quotas

  service_code = data.aws_servicequotas_service_quota.this[each.key].service_code
  quota_code   = data.aws_servicequotas_service_quota.this[each.key].quota_code

  # The provider requests any differing value as an increase, which AWS rejects
  # for values below the current quota. Never ask for less than AWS already grants.
  value = max(each.value.limit, data.aws_servicequotas_service_quota.this[each.key].value)
}

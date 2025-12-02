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

# Apply a service quota request if the requested quota is higher than the actual quota.
# If it is lower, the Tofu plan will simply apply without making an API call.
# This will only error if the requested quota is lower than the default.
resource "aws_servicequotas_service_quota" "this" {
  for_each = local.service_quotas

  service_code = data.aws_servicequotas_service_quota.this[each.key].service_code
  quota_code   = data.aws_servicequotas_service_quota.this[each.key].quota_code
  value        = each.value.limit
}

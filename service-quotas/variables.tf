variable "service_quotas" {
  type        = map(map(number))
  description = <<EOF
AWS Service Quotas define the limits for usage of various AWS services.
This variable is a nested map, where the parent key is the name of the service,
and the child key is the name of the quota. The value is the requested limit.

The aws_servicequotas_service_quota resource in this module expects service and quota codes.
Instead, we use the defined names and look up the codes using data sources.
This ensures that the quotas defined here are understandable without relying on comments
that may be forgotten or out of date.

You can find a list of service names using the AWS CLI:
`aws service-quotas list-services`

Using code for the service (not the name), you can list the available quotas for that service:
`aws service-quotas list-service-quotas --service=$SERVICE_CODE`

Service and quota names are also shown in the AWS console.
EOF

  default = {
    "Amazon Virtual Private Cloud (Amazon VPC)" = {
      "VPCs per Region"                    = 50
      "NAT gateways per Availability Zone" = 50
      "IPv4 CIDR blocks per VPC"           = 50
    }
    "Route 53 Resolver" = {
      "Maximum number of resolver endpoints per AWS Region" = 100
    }
    "Amazon Elastic Compute Cloud (Amazon EC2)" = {
      "EC2-VPC Elastic IPs" = 100
      # Value is the number of vCPUs for all running or requested instances.
      "All Standard (A, C, D, H, I, M, R, T, Z) Spot Instance Requests" = 1152
      # Value is the number of vCPUs for all running or requested instances.
      "Running On-Demand Standard (A, C, D, H, I, M, R, T, Z) instances" = 1152
    }
    "Elastic Load Balancing (ELB)" = {
      "Classic Load Balancers per Region" = 50
    }
    "Amazon EC2 Auto Scaling" = {
      "Auto Scaling groups per region"   = 500
      "Launch configurations per region" = 500
    }
  }
}

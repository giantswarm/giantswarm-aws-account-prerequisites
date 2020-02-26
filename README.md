# giantswarm-aws-account-prerequisites
This repo contains a terraform module configuration to prepare an AWS account to run Giant Swarm tenant clusters.

## Before starting
Read the docs [here](https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/) and be sure we are fine in terms of AWS account limits.

## Prepare the control plane account

Run the module in the **control plane account**:

```hcl
module "giantswarm-cp-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//control-plane-account"
}

output "user-access-key-id" {
  value = "${module.giantswarm-cp-prereqs.user-access-key-id}"
}

output "user-access-key-secret" {
  value = "${module.giantswarm-cp-prereqs.user-access-key-secret}"
}
```

Get the access key ID and secret from the output - these must be provided to Giant Swarm.

## Prepare the tenant cluster account

Ensure you set the `main_account_id` variable to the ID of the main account used in the previous step.

Run the module in the **tenant cluster account**:

```hcl
module "giantswarm-tc-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//tenant-cluster-account"
  main_account_id = "111111111111"
}

output "aws-operator-role-arn" {
  value = "${module.giantswarm-tc-prereqs.aws-operator-role}"
}
```

Get the AWSOperator role ARN from the output - this must be provided to Giant Swarm.

## Configure organizations

`gsctl update organization set-credentials --aws-operator-role $(terraform output aws-operator-role) --aws-admin-role $(terraform output giantswarm-admin-role)`

It is explained here.
https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#configure-org

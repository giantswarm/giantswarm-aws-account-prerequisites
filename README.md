# giantswarm-aws-account-prerequisites 
This repo contains a terraform module configuration to prepare an AWS account to run Giant Swarm tenant clusters.

## Before start.
Read the docs [here](https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/) and be sure we are fine in terms of AWS account limits.

## Run the module
Run the terraform module like this.

```hcl
module "giantswarm-prerequisites" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites"
}

output "aws-operator-role" {
  value = module.giantswarm-prerequisites.aws-operator-role
}

output "giantswarm-admin-role" {
  value = module.giantswarm-prerequisites.giantswarm-admin-role
}

```
Get the output for aws-admin-role and aws-operator-role.

## Configure organizations 

`gsctl update organization set-credentials --aws-operator-role $(terraform output aws-operator-role)` 

`gsctl update organization set-credentials --aws-admin-role $(terraform output aws-admin-role)`


It is explained here.
https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#configure-org
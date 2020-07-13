# giantswarm-aws-account-prerequisites
This repo contains Terraform modules to prepare AWS accounts to run Giant Swarm clusters.

## Before starting
Read the docs [here](https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/) and be sure we are fine in terms of AWS account limits.

If you plan on having Tenant Clusters on the same AWS account as your Control Plane you will need to execute both modules **control plane account** and **tenant cluster account** against the same AWS account. Additionaly you can execute **tenant cluster account** module on sepparate accounts to have unique credentials per organization.

## Prepare the control plane account

Run the module in the **control plane account** :

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

Note: as the access key ID and secret are output in plaintext, they will also be included in your
Terraform state file. Please take this into consideration when using this module. If this isn't
acceptable then it is possible to encrypt the secret using a [PGP key, or a keybase user](https://www.terraform.io/docs/providers/aws/r/iam_access_key.html#pgp_key)

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

Note: the control plane account _must_ be prepared first, otherwise the tenant cluster module will fail
because the control plane AWSOperator user ARN will not exist yet.

## Configure organizations

`gsctl update organization set-credentials --aws-operator-role $(terraform output aws-operator-role) --aws-admin-role $(terraform output giantswarm-admin-role)`

It is explained here.
https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#configure-org

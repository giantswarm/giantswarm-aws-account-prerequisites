# giantswarm-aws-account-prerequisites
This repo contains Terraform modules to prepare AWS accounts to run Giant Swarm clusters.

## Before starting
Read the docs [here](https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/) and be sure we are fine in terms of AWS account limits.

There are three modules in this repository:

1) [Admin access](./admin-access) which provisions a role and a policy for our staff to be able to operate the infrastructure created by our automation in case of failures.

2) [Control Plane AWS user](./control-plane-aws-user) which creates a user and a policy to be used for our automation to manage the infrastructure in the AWS account of the control plane.

1) [Tenant AWS role](./tenant-aws-role) which takes care of provisioning the role and policy to be assumed for the automation to create and manage resources on the Tenant AWS account where clusters will run. 

## 1. Admin Access

For all AWS accounts part of the platform, does not matter if they are for control plane or tenant clusters, we need to have access in order to debug and operator the infrastructure. To do so, please run this module in the target account:

```hcl
module "giantswarm-cp-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//admin-access"
}

output "giantswarm-admin-role" {
  value = "${module.giantswarm-cp-prereqs.giantswarm-admin-role}"
}
```

The role name is by default `GiantSwarmAdmin` but it can be replaced passing a variable `admin_role_name` in case it is needed.

The Admin Role ARN needs to be supplied to Giant Swarm.

## 2. Control Plane AWS Cluster

Previous to provision the Control Plane cluster, Giant Swarm needs a IAM user to be used for the automation in AWS account which will hold the Control Plane resources. To do so, please run this module in the target account:

```hcl
module "giantswarm-cp-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//control-plane-aws-user"
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

## 3. Tenant AWS Role

Now, for each AWS Tenant account you need to run this module to enable our automation to assume the role in order to manage all clusters resources. You will need to provide the `main_account_id` used in step before for the Control Plane and the `tenant_account_id` with the target AWS account ID you need to setup.

```hcl
module "giantswarm-tc-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//tenant-aws-role"
  main_account_id = "111111111111"
  tenant_account_id = "22222222222"
}

output "aws-operator-role-arn" {
  value = "${module.giantswarm-tc-prereqs.aws-operator-role}"
}
```

The role name is by default `GiantSwarmRoleAWSOperator` but it can be replaced passing a variable `operator_role_name` in case it is needed.

The AWS Operator Role ARN needs to be supplied to Giant Swarm.

__Note__: the Control Plane account _must_ be prepared first, otherwise the tenant cluster module will fail because the Control Plane AWS Operator user ARN will not exist yet.

## Configure organizations

In case you are adding a new organization that runs in a new AWS Account, you need to apply step `1` and `3`. With the outputs you can run this `gsctl` command to setup the new configuration.

`gsctl update organization set-credentials --aws-operator-role $(terraform output aws-operator-role) --aws-admin-role $(terraform output giantswarm-admin-role)`

It is explained here.
https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#configure-org

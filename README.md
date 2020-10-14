# giantswarm-aws-account-prerequisites

This repo contains Terraform modules to prepare AWS accounts to run Giant Swarm
clusters.

## Before starting

Make sure to adjust AWS account limits according to [these
docs](https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#limits).

There are three modules in this repository:

1. [admin-role](./admin-role) which creates a role and a policy for our
   staff to be able to operate the infrastructure created by our automation in
   case of failures.
2. [aws-operator-user](./aws-operator-user) which creates a user and its policy
   to be used for our automation to manage the infrastructure.
3. [aws-operator-role](./aws-operator-role) which creates
   the role and policy to be assumed for the automation user to create and manage
   resources.

## 1. admin-role

For all AWS accounts part of the platform, does not matter if they are for
control plane or tenant clusters, we need to have access in order to debug and
operator the infrastructure. To do so, please run this module in the target
account:

```hcl
module "giantswarm-cp-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//admin-access"
}

output "giantswarm-admin-role" {
  value = "${module.giantswarm-cp-prereqs.giantswarm-admin-role}"
}
```

The created role and policy name is `GiantSwarmAdmin`.

The created role ARN needs to be supplied to Giant Swarm.

## 2. aws-operator-user

Giant Swarm needs a IAM user to be used for the automation in AWS some account.
This is usually the Control Plane AWS account but it doesn't have to. To do so,
please run this module in the target account:

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

The created user name is `GiantSwarmAWSOperator` and its policy name is
`GiantSwarmUserAWSOperator`.

Get the access key ID and secret from the output - these must be provided to Giant Swarm.

**Note:** as the access key ID and secret are output in plaintext, they will
also be included in your Terraform state file. Please take this into
consideration when using this module. If this isn't acceptable then it is
possible to encrypt the secret using a [PGP key, or a keybase
user](https://www.terraform.io/docs/providers/aws/r/iam_access_key.html#pgp_key)

## 3. aws-operator-role

Now, for the Control Plane account and each AWS Tenant account you need to run
this module to enable our automation to assume the role in order to manage all
clusters resources.

You will need to provide the `main_account_id` which is the AWS account ID where
`GiantSwarmAWSOperator` user was created (using `aws-operator-user` module) and
`target_account_id` which is the AWS account ID of provisioned Control Plane or
Tenant Cluster AWS account.

```hcl
module "giantswarm-tc-prereqs" {
  source = "git@github.com:giantswarm/giantswarm-aws-account-prerequisites//aws-operator-role"
  main_account_id = "111111111111"   # Account with GiantSwarmAWSOperator user.
  target_account_id = "22222222222"  # Account to create role in.
}

output "aws-operator-role-arn" {
  value = "${module.giantswarm-tc-prereqs.aws-operator-role}"
}
```

The role and policy name is `GiantSwarmAWSOperator`.

The AWS Operator Role ARN needs to be supplied to Giant Swarm.

## Adding new Tenant Cluster account

In case you are adding a new organization that runs in a new AWS Account, you
need to apply step `1` and `3`. With the outputs you can run this `gsctl`
command to setup the new configuration.

`gsctl update organization set-credentials --aws-operator-role $(terraform output aws-operator-role) --aws-admin-role $(terraform output giantswarm-admin-role)`

It is explained here.
https://docs.giantswarm.io/guides/prepare-aws-account-for-tenant-clusters/#configure-org

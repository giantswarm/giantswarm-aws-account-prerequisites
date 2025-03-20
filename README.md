# giantswarm-aws-account-prerequisites

This repository contains OpenTofu / Terraform configuration to prepare AWS accounts for running Giant Swarm clusters based on Cluster API Provider for AWS (CAPA).

Note that this repo is intended for Giant Swarm customers to setup the initial admin role and to provide some transparency on the different IAM policies that will be used by CAPA and other components. But it's not to be used by Giant Swarm staff to manage AWS IAM resources directly, head to <https://github.com/giantswarm/aws-account-setup/> for that.

## Before starting

Make sure to adjust AWS account limits according to [these docs](https://docs.giantswarm.io/getting-started/prepare-your-provider-infrastructure/aws/#quotas). Then please create the admin role for Giant Swarm staff access, as shown below.

## admin-role

In all AWS accounts where you plan to run a management cluster and workload clusters, Giant Swarm staff need to have access in order to manage, operate and troubleshoot the infrastructure.

Therefore, please run OpenTofu or Terraform using the configuration provided in the `admin-role` directory, using AWS credentials for the account where the role needs to be created.

```console
export AWS_PROFILE=example
tofu init
tofu apply # review the proposed changes before approving
```

**Once the admin role is created, Giant Swarm staff will take over the maintenance of it and the CAPA controller roles for all the MCs that operate under that account, so there is no further action needed by customers.**

## capa-controller-role

The Cluster API Provider AWS (CAPA) controller requires an IAM role to assume in order to create and manage clusters and all infrastructure resources in a specific AWS account. As mentioned above, the lifecycle of this role is normally managed by Giant Swarm once the admin role is provisioned.

But in case that for some reason the CAPA controller role needs to be managed individually by the customer, the OpenTofu / Terraform configuration in the `capa-controller-role` directory can be used, using AWS credentials for the account where the role needs to be created.

### Adjust variables

Note that for this stack there are some additional variables that you need to provide:

- `installation_name`: the name of the installation which you have agreed with Giant Swarm upfront.
- `management_cluster_oidc_provider`: the name of the MC OIDC provider. Normally `irsa.<cluster-base-domain>`.
- `byovpc` (optional - defaults to `false`): if `true`, the CAPA role will be created without the permissions needed to manage VPCs
- `eks` (optional - defaults to `false`): if `true`, the CAPA role will be created with the permissions needed to manage EKS clusters

### Execution

```console
export AWS_PROFILE=example
export TF_VAR_installation_name=foo
export TF_VAR_management_cluster_oidc_provider=irsa.foo.bar.com
export TF_VAR_byovpc=false
tofu init
tofu apply # review the proposed changes before approving
```

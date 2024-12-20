# giantswarm-aws-account-prerequisites

This repo contains Cloud Formation templates to prepare AWS accounts for running Giant Swarm clusters based on Cluster API Provider for AWS (CAPA).

## Before starting

Make sure to adjust AWS account limits according to [these docs](https://docs.giantswarm.io/getting-started/prepare-your-provider-infrastructure/aws/#quotas). Then please create the admin role for Giant Swarm staff access, as shown below.

## 1. admin-role

In all AWS accounts where you plan to run a management cluster and workload clusters, Giant Swarm staff need to have access in order to manage, operate and troubleshoot the infrastructure.

Therefore, please create the admin CloudFormation stack in each of those accounts. That can be done either from our [admin role stack template (direct link to AWS Console dialog)](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/quickcreate?templateURL=https://cf-templates-giantswarm.s3.eu-central-1.amazonaws.com/admin-role/cloud-formation-template.yaml&stackName=GiantSwarmAdminRoleBootstrap&&param_AdminRoleName=GiantSwarmAdmin), or by uploading the [admin role stack definition file](./admin-role/cloud-formation-template.yaml) when creating a new stack in the AWS console.

Review the changes and click `Create stack`. In case of any error, please check the `Events` tab in the CloudFormation console and report the error to the Giant Swarm staff.

## 2. capa-controller-role

In the AWS account where you plan to run the management cluster, you need to create a role that the Cluster API Provider AWS (CAPA) controller will assume to create and manage workload clusters and all infrastructure resources.

The same applies to all accounts where CAPA should be able to create workload clusters, since they don't necessarily need to run in the same account as your management cluster. The `AWSClusterRoleIdentity` objects on the management cluster define in which accounts you want to create workload clusters.

**Once the admin role is created (see above), Giant Swarm staff takes over creating and maintaining the CloudFormation stack for each of your desired accounts and there is no further action needed by customers. Only if for some reason, you want to manage them yourself**, you can use these instructions:

- Creation: Log into the right account in AWS Console, choose your desired region and create the CloudFormation stack from our [capa-controller-role stack template (direct link to AWS Console dialog)](https://eu-central-1.console.aws.amazon.com/cloudformation/home?region=eu-central-1#/stacks/quickcreate?templateURL=https://cf-templates-giantswarm.s3.eu-central-1.amazonaws.com/capa-controller-role/cloud-formation-template.yaml&stackName=CAPAControllerRoleBootstrap&param_InstallationName=CHANGE_THIS_FOR_THE_INSTALLATION_NAME&param_ManagementClusterOidcProviderDomain=MANAGEMENT_CLUSTER_OIDC_PROVIDER_DOMAIN). Alternatively, you can upload the [capa-controller-role stack definition file](./capa-controller-role/cloud-formation-template.yaml) in this repository.

  You will be asked for the following parameters:

  - `InstallationName`: the name of the installation which you have agreed with Giant Swarm upfront.
  - `ByoVpc` (optional - defaults to `false`): if `true`, the CAPA role will be created without the permissions needed to manage VPCs. Turn this on if you only want to create clusters in VPCs that you have already created, without requiring CAPA to create or manage VPCs and its networking resources (like NAT/internet gateways, subnets, etc.).
  - `ManagementClusterOidcProviderDomain`: the domain name used by the MC OIDC provider. Normally `irsa.<cluster-base-domain>`.

  Review the changes and click `Create stack`. In case of any error, please check the `Events` tab in the CloudFormation console and report the error to the Giant Swarm staff.
- Update: Select the CloudFormation stack in AWS Console, then `Update > Replace existing template` and use the latest released definition `https://cf-templates-giantswarm.s3.eu-central-1.amazonaws.com/capa-controller-role/cloud-formation-template.yaml` as source (or the [stack definition file](./capa-controller-role/cloud-formation-template.yaml) in this repository).

# giantswarm-aws-account-prerequisites

This repo contains Cloud Formation templates and Terraform modules to prepare AWS accounts to run Giant Swarm clusters.

# Cluster API

## Before starting

Make sure to adjust AWS account limits according to [these docs](https://docs.giantswarm.io/getting-started/cloud-provider-accounts/cluster-api/aws/#limits).

For Cluster API take a look at these two modules in this repository:

1. [admin-role](./admin-role) which creates a role and a policy for our staff to be able to operate the infrastructure created by our automation in case of failures.
2. [capa-controller-role](./capa-controller-role) which creates the role and policies that the controllers assume to create and manage the kubernetes clusters.

## 1. admin-role

For all AWS accounts part of the platform  Giant Swarm staff need to have access in order to debug and
manage and operate the infrastructure. To do so, please use one of the following methods to create the necessary role and policy in your AWS account.

### AWS CloudFormation template

You can execute directly the CloudFormation template clicking [here](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?templateURL=https://my-s3-bucket.s3.amazonaws.com/giantswarm-template.yaml&stackName=GiantSwarmAdminRoleBootstrap) or uploading the [template file](./admin-role/cloud-formation-template.yaml) when creating a new stack in the AWS console.

You will be asked for the following parameters:

- `AdminRoleName`: The name of the role that will be created. Default is `GiantSwarmAdmin`. You dont need to change this unless you have a specific requirement.

Review the changes and click `Create stack`. In case of any error, please check the `Events` tab in the CloudFormation console and report the error to the Giant Swarm staff.

### Terraform

#### Requirements

- `terraform` installed
- working AWS credentials set to the desired target account
- AWS region has to be set  either via aws profile or via env `AWS_REGION`

### Adjust variables

- `principal_arns_giantswarm_root_account` - can be adjusted to be more strict and specify user which will assume the role. Default is `arn:aws:iam::084190472784:root`. You dent need to change this unless you have a specific requirement.
- `admin_role_name` - can be adjusted to be more strict and specify role name. You dent need to change this unless you have a specific requirement.

### Execution

```
terraform init .
terraform apply -var="admin_role_name=GiantSwarmAdmin
```

The created role ARN needs to be supplied to Giant Swarm.

## 2. capa-controller-role

In the AWS account where you plan to run the management cluster, you need to create a role that the Cluster API controllers will assume to create and manage workload clusters and all infrastructure resources.

### AWS CloudFormation template

You can execute directly the CloudFormation template clicking [here](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?templateURL=https://my-s3-bucket.s3.amazonaws.com/giantswarm-template.yaml&stackName=GiantSwarmControllerRoleBootstrap) or uploading the [template file](./capa-controller-role/cloud-formation-template.yaml) when creating a new stack in the AWS console.

You will be asked for the following parameters:

- `InstallationName`: The name of the installation which you have agreed with Giant Swarm upfront.

Review the changes and click `Create stack`. In case of any error, please check the `Events` tab in the CloudFormation console and report the error to the Giant Swarm staff.

### Terraform

#### Requirements

- `terraform` installed
- working AWS credentials set to the desired target account
- AWS region has to be set  either via aws profile or via env `AWS_REGION`

### Adjust variables

- `principal_arns_giantswarm_root_account` - can be adjusted to be more strict and specify user which will assume the role - ie `arn:aws:iam::084190472784:user/${INSTALLATION_NAME}-capa-controller`
- `installation_name` - the name of the installation which you have agreed with Giant Swarm upfront.

### Execution

```
terraform init .
terraform apply -var="installation_name=test"
```

## AWS cli

### Requirements

- `awscli` installed
- `envsubst` tool
- `jq` installed
- working AWS credentials set to the desired target account
- located on the `capa-controller-role` directory of this git repo
- user `${INSTALLATION}-capa-controller` created in GiantSwarm account `084190472784`

### Setup

```
export INSTALLATION_NAME=test
chmod +x setup.sh
./setup.sh
```

### Cleanup

```
export INSTALLATION_NAME=test
chmod +x cleanup.sh
./cleanup.sh
```
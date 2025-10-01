# giantswarm-aws-account-prerequisites

This repository contains OpenTofu / Terraform configuration to prepare AWS accounts for running Giant Swarm clusters based on Cluster API Provider for AWS (CAPA).

Note that this repo is intended for Giant Swarm customers to setup the initial admin role and to provide some transparency on the different IAM policies that will be used by CAPA and other components. But it's not to be used by Giant Swarm staff to manage AWS IAM resources directly, head to <https://github.com/giantswarm/aws-account-setup/> for that.

## Giant Swarm customers - New AWS account onboarding

Follow the instructions in the [onboarding directory](./onboarding/README.md) to onboard a new AWS account.

## OpenTofu modules in this repository

### capa-controller-role

IAM role for the Cluster API Provider AWS (CAPA) controller to assume in order to create and manage clusters and all infrastructure resources in the AWS account.

### read-role

The read role is used by our automation to validate pull requests on our infrastructure code.

### admin-role

The admin role is used by Giant Swarm staff and our automation for making changes.

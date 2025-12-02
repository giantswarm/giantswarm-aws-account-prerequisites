# giantswarm-aws-account-prerequisites

This repository contains OpenTofu configuration to prepare AWS accounts for running Giant Swarm clusters based on Cluster API Provider for AWS (CAPA).

Note that this repo is intended for Giant Swarm customers to setup the initial admin role and to provide some transparency on the different IAM policies that will be used by CAPA and other components. But it's not to be used by Giant Swarm staff to manage AWS IAM resources directly, head to <https://github.com/giantswarm/aws-account-setup/> for that.

## Giant Swarm customers - new AWS account onboarding

Follow the instructions in the [onboarding directory](./onboarding/README.md) to onboard a new AWS account.

## OpenTofu modules in this repository

### admin-role

**Purpose**: Used by Giant Swarm staff and automation for making changes to AWS infrastructure.

**Key Permissions**:

- **Full access** to most AWS services including EC2, S3, CloudWatch, Route53, ELB, Auto Scaling, ECR, EFS, CloudTrail, and EventBridge
- **Comprehensive IAM management** for roles, policies, instance profiles, and OIDC providers (excluding user/group management)
- **Read-only access** to CloudFormation, DynamoDB, and KMS
- **Conditional restrictions**: When `byovpc=true`, VPC-related EC2 actions are denied to prevent modification of customer-managed VPCs
- **Security guardrails**: Deletion actions for CloudTrail, ECR repositories, and CloudWatch resources are explicitly denied

### read-role

**Purpose**: Used by automation to validate pull requests on infrastructure code with read-only access.

**Key Permissions**:

- **Read-only access** to all major AWS services including EC2, S3, IAM, CloudWatch, Route53, Auto Scaling, ELB, ECR, EFS, CloudTrail, and EventBridge
- **No write/modify permissions** - strictly limited to describe, get, and list operations

### capa-controller-role

**Purpose**: IAM role for the Cluster API Provider AWS (CAPA) controller to create and manage Kubernetes clusters and supporting infrastructure.

**Key Permissions**:

- **Core CAPA operations**: EC2 instance lifecycle, security groups, launch templates, Auto Scaling groups, and Elastic Load Balancers
- **VPC management** (when not BYO VPC): Create/manage VPCs, subnets, route tables, internet gateways, and NAT gateways
- **DNS management**: Full Route53, Route53 Domains, and Route53 Resolver permissions
- **IAM management**: Create/manage roles and instance profiles for cluster nodes and services
- **EKS support** (optional): Full EKS cluster and node group management, including add-ons and Fargate profiles
- **Storage**: S3 bucket management for cluster artifacts and backups
- **Service integration**: EventBridge rules, SQS queues, Secrets Manager, and service-linked role creation
- **Crossplane support**: Additional permissions for infrastructure provisioning via Crossplane
- **IRSA and network topology**: Support for IAM Roles for Service Accounts and network topology management

**Trust Relationships**: Can be assumed by Giant Swarm's CAPA controller user and by specific Kubernetes service accounts via OIDC (Web Identity).

### service-quotas

**Purpose**: A set of sensible default AWS Service Quotas for running Giant Swarm clusters.

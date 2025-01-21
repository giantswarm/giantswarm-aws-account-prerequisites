# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add `directconnect:*` permissions to admin role.
- Add `cloudtrail:*` permissions to admin role.

## [5.0.0] - 2025-01-14

### Changed

- Reduce setup options to only OpenTofu / Terraform

## [4.3.1] - 2024-12-18

### Changed

- Allow `iam:TagPolicy` to GS staff in order to update prerequisites IAM policies
- Avoid Terraform replacing IAM role/policies if only description field changed

## [4.3.0] - 2024-12-05

### Changed

- Add support for removing some IAM permissions from the capa controller role in BYOVPC installations.
- CAPA role CloudFormation template: switch from inline to managed policies for the CAPA IAM role.
- Add CAPA permissions for ASG lifecycle hooks
- Add support for AWS China
- Add support for custom GS staff account

## [4.2.0] - 2024-09-04

### Changed

- Add support for Crossplane usage on the CAPA controller role
- Add ability to import existing IAM resources into Terraform state for the CAPA controller role

### Fixed

- Fixed terraform file to use correct GiantSwarm root account for the user that will assume the capa-controller role.

## [4.1.0] - 2024-08-20

### Added

- For cluster cleanup purposes, add the permissions `s3:GetBucketTagging` and `s3:ListAllMyBuckets` in order to scan for buckets owned by a management/workload cluster. Those buckets may not have a fixed name pattern (e.g. include AWS region or other dynamic string) and therefore searching by "owned" tag allows us to find and delete all such resources.
- For cluster cleanup purposes, tag all IAM roles and policies with the installation name, so they are easily identifiable during cleanup / teardown.
- Add `ec2:ReplaceRoute` permissions to the CAPA controller role.
- Add `ec2:DescribeDhcpOptions` permissions to the CAPA controller role, required by CAPA releases >= `v2.4.0`.

## [4.0.0] - 2024-07-15

### Added

- Add `iam:ListRoleTags` and `iam:UntagRole` permissions to the AWS operator role.
- CAPA: add new `mc-bootstrap` policy to `capa-controller` role.
- Add IAM policy for use with Crossplane AWS provider. The initial permissions are meant to be used with Cilium ENI mode.
- CAPA: add `autoscaling:CancelInstanceRefresh` permission (needed for `AWSMachinePool` reconciler [improvement](https://github.com/giantswarm/cluster-api-provider-aws/pull/598))
- Create a CloudFormation stack to manage the IAM policies and roles.

### Changed

- Use a setup script to automate CAPA controller commands.

### Removed

- Remove vintage setup instructions.

## [3.4.0] - 2024-01-16

### Changed

- Add S3 permission for CAPA polices in order to run on Flatcar.
- Remove non-existent IAM actions.

### Added

- Add `s3:PutBucketOwnershipControls` to irsa policy. Needed because of [this change](https://github.com/giantswarm/irsa-operator/commit/2437798672c74cfae15162a561629c6565dbee41) in irsa-operator
- Add `"ec2:DescribeInstanceTypes"` to the CAPA controller policy, as it's required by newest CAPA releases.
- Add EKS permissions for managed node pools, encryption/identity provider configs, CIDR blocks, KMS.
- CAPA: add `s3:GetObject` permission for CAPA (needed for new [S3 object cleanup feature](https://github.com/kubernetes-sigs/cluster-api-provider-aws/pull/4667))

## [3.3.0] - 2023-05-11

### Changed

- Add Workload cluster AWS account id to `sqs` and `events` IAM permission.

## [3.2.0] - 2023-04-27

### Added

- Add SQS permission for NodeTerminationHandler/Karpenter.
- Add Events permissions for NodeTerminationHandler/Karpenter.
- Add ssm:GetParameter for NodeTerminationHandler/Karpenter.

## [3.1.0] - 2023-04-27

### Added

- Add s3:PutBucketOwnershipControls permissions for GiantSwarmAWSOperator.


## [3.0.0] - 2023-03-31

### Added

- Extend `GiantSwarmAdmin` policy to allow EFS service.
- Extend all policies with `iam:TagRole` to fix missing tags.
- Extend `GiantSwarmAdmin` policy with permissions for policy view and last access service.
- Add `sqs:*` permission to admin role.
- Add `iam:*OpenIDConnectProvider` permissions to support IAM roles for service accounts.
- Add `s3:PutObjectAcl` for uploading public objects.
- Add `ec2:CreateNetworkInterface` permission for resolver rules operator.

### Changed

- Limit S3 permissions for `GiantSwarmAWSOperator`
- Added `sns:Publish` permission to network-topology-operator policy
- Update permissions for resolver rules operator.
- Extend IAM permissions for `GiantSwarmAdmin` to allow rotating secrets.

### Removed

- Remove unused service permissions in `GiantSwarmAWSOperator`.

### Fixed

- Updated README with correct directories

## [2.0.0] - 2020-09-04

### Added

- Extend aws-operator policy with permissions required on control-plane
  account.
- Extract `arn_prefix` variable in `aws-operator-role` module to support CN
  regions.
- Extract `operator_user_name` variable in `aws-operator-role` module.
- Add `LisUsers` and `GetPolicyVersion` in `admin-access` policy.

### Changed

- Set role name to fixed value `GiantSwarmAWSOperator` in `aws-operator-role`
  module.
- Update aws-operator policy with additional IAM `role/*-vpc-peer-access`
  resource to the in `aws-operator-role` module.
- Rename `tenant-aws-role` module to `aws-operator-role`.
- Rename `admin-role` module to `adming-role`.
- Rename `control-plane-aws-user` module to `aws-operator-user`.
- Rename variable `tenant_accout_id` to `target_account_id` in
  `aws-operator-role` module.

### Removed

- Remove `operator_role_name` variable from `aws-operator-role` module.

### Fixed

- Fix policy versioning by storing it locally inside the module.

## [1.0.0] - 2020-09-04

### Added

- First release.

[Unreleased]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v5.0.0...HEAD
[5.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v4.3.1...v5.0.0
[4.3.1]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v4.3.0...v4.3.1
[4.3.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.4.0...v4.0.0
[3.4.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.1.0...v3.0.0
[3.1.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/releases/tag/v1.0.0

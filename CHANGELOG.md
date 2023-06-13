# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Add `S3` permission for CAPA polices in order to run on Flatcar.
- Remove not existing IAM actions.

### Added

- Add `s3:PutBucketOwnershipControls` to irsa policy. Needed because of [this change](https://github.com/giantswarm/irsa-operator/commit/2437798672c74cfae15162a561629c6565dbee41) in irsa-operator

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

[Unreleased]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.3.0...HEAD
[3.3.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.1.0...v3.0.0
[3.1.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/releases/tag/v1.0.0

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Add IAM `role/*-vpc-peer-access` resource management to the aws-operator
  policy in `aws-operator-role` policy.
- Rename `tenant-aws-role` module to `aws-operator-role`. It should be run on
  Control Plane account as well now.
- Rename variable `tenant_accout_id` to `target_account_id` in
  `aws-operator-role` module.

### Fixed

- Fix policy versioning by storing it locally inside the module.

## [1.0.0] - 2020-09-04

### Added

- First release.

[Unreleased]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/giantswarm/giantswarm-aws-account-prerequisites/releases/tag/v1.0.0

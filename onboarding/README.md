# 🚀 New AWS account onboarding

Follow these steps to onboard a new AWS account to use with the Giant Swarm platform.

*Note* that the OpenTofu code in this repository is only provided as a means of onboarding a new AWS account, but it shouldn't be used by customers for active maintenance. Giant Swarm will take over maintenance of these and the CAPA controller IAM roles for all the management clusters that operate under that account. Therefore, you do not need to persist the OpenTofu state file.

## Before starting

Make sure to adjust AWS account limits according to [these docs](https://docs.giantswarm.io/getting-started/prepare-your-provider-infrastructure/aws/#quotas).

## IAM roles setup

In all AWS accounts where you plan to run management clusters and workload clusters, Giant Swarm staff need access to manage, operate, and troubleshoot the infrastructure.

The following roles will be created:

- **`GiantSwarmAdmin`** - Used by Giant Swarm staff and automation for making changes
- **`GiantSwarmReadOnly`** - Used by automation to validate pull requests on infrastructure code

To set up these roles, run OpenTofu using the configuration in this directory (`onboarding`):

```console
export AWS_PROFILE=example # Set the aws-cli profile for the account you are onboarding
tofu init
tofu apply
```

## Final step

**Once the roles are created, provide the new AWS account ID to Giant Swarm staff.**

You can disregard the generated OpenTofu state.

**That's it!** From then on, we will take over the maintenance of these and the CAPA controller IAM roles for all the management clusters that operate under that account. No further action is needed from your side.

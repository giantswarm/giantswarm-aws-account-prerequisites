#!/usr/bin/env bash

set -eu

ACCOUNT=$1

# GET LATEST VERSION
curl -XGET https://raw.githubusercontent.com/giantswarm/aws-operator/master/policies/tenant_cluster.json > ./generic-resources/iam-policy.json

# REPLACE THE AWS ACCOUNT ID
sed -i '' "s/<CUSTOMER_ACCOUNT_ID>/$ACCOUNT/g" ./generic-resources/iam-policy.json

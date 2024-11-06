#!/bin/bash

set -u

BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ROLE_NAME="giantswarm-${INSTALLATION_NAME}-capa-controller"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output text --query 'Account')"

POL_TYPES=("capa-controller" "capa-controller-vpc" "dns-controller" "eks-controller" "iam-controller" "irsa-operator" "resolver-rules-operator" "network-topology-operator" "mc-bootstrap" "crossplane")
POL_ARN_PREFIX="arn:aws:iam::${AWS_ACCOUNT_ID}:policy"

function echo_fail_or_success {
	s=$1
	if [ "$s" != 0 ]; then
		echo -e "${RED}  failed${NC}"
	else
		echo -e "${GREEN}  success${NC}"
	fi
}

echo -e "${BLUE}Role name: ${ROLE_NAME}${NC}"
for pol_type in ${POL_TYPES[@]}; do
	POL_NAME="giantswarm-${INSTALLATION_NAME}-${pol_type}-policy"
	POL_ARN="$POL_ARN_PREFIX/$POL_NAME"

	echo -n "|_ Detaching policy ${POL_NAME}..."
	aws iam detach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${POL_ARN}"
	echo_fail_or_success "$?"

	echo -n "|_ Delete policy ${POL_NAME}..."
	aws iam delete-policy --policy-arn "${POL_ARN}"
	echo_fail_or_success "$?"
done

echo -n "|_ Deleting role..."
aws iam delete-role --role-name "${ROLE_NAME}"
echo_fail_or_success "$?"

exit 0

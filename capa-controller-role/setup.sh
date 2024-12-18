#!/bin/bash

set -u

BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ROLE_NAME="giantswarm-${INSTALLATION_NAME}-capa-controller"
POL_TYPES=("capa-controller" "dns-controller" "eks-controller" "iam-controller" "irsa-operator" "resolver-rules-operator" "network-topology-operator" "mc-bootstrap" "crossplane")
TAGS="Key=installation,Value=${INSTALLATION_NAME}"
BYOVPC=${BYOVPC:-false}
AWS_PARTITION=${AWS_PARTITION:-aws}
GS_USER_ACCOUNT=${GS_USER_ACCOUNT:-"084190472784"}

if [ "$BYOVPC" == "false" ]; then
	# This policy is not needed in BYO VPC installations
	POL_TYPES+=("capa-controller-vpc")
fi

function echo_fail_or_success {
	s=$1
	if [ "$s" != 0 ]; then
		echo -e "${RED}  failed${NC}. Please review the required permissions and try again."
	else
		echo -e "${GREEN}  success${NC}"
	fi
}

function create_role {
  export AWS_ACCOUNT_ID
  envsubst < ./trusted-entities.json > ${INSTALLATION_NAME}-trusted-entities.json
  aws iam create-role --role-name "${ROLE_NAME}" --description "Giant Swarm managed role for k8s cluster creation" --assume-role-policy-document file://${INSTALLATION_NAME}-trusted-entities.json --tags ${TAGS}
	err=$?
  rm -f ${INSTALLATION_NAME}-trusted-entities.json
	return $err
}

function create_policy {
  policy_arn=$(aws iam create-policy --policy-name $2 --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://$1-policy.json --tags ${TAGS} | jq -r '.Policy.Arn')
  aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${policy_arn}"
}

export AWS_PAGER=""
echo -n "|_ Creating the role ${ROLE_NAME}..."
create_role
echo_fail_or_success "$?"

# Create policies
for pol_type in ${POL_TYPES[@]}; do
	pol_name="giantswarm-${INSTALLATION_NAME}-${pol_type}-policy"

	echo -n "|_ Create policy ${pol_name}..."
	create_policy "${pol_type}" "${pol_name}"
  echo_fail_or_success "$?"
done

exit 0

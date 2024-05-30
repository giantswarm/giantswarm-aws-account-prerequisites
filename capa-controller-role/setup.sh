#!/bin/bash

set -u

BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ROLE_NAME="giantswarm-${INSTALLATION_NAME}-capa-controller"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output text --query 'Account')"

POL_TYPES=("capa-controller" "dns-controller" "eks-controller" "iam-controller" "irsa-controller" "resolver-rule-operator" "network-topology-controller" "mc-bootstrap" "crossplane")
POL_ARN_PREFIX="arn:aws:iam::${AWS_ACCOUNT_ID}:policy"

function echo_fail_or_success {
	s=$1
	if [ "$s" != 0 ]; then
		echo -e "${RED}  failed${NC}"
	else
		echo -e "${GREEN}  success${NC}"
	fi
}

function create_role {
  envsubst < ./trusted-entities.json > ${INSTALLATION_NAME}-trusted-entities.json
  aws iam create-role --role-name "${ROLE_NAME}" --description "Giant Swarm managed role for k8s cluster creation" --assume-role-policy-document file://${INSTALLATION_NAME}-trusted-entities.json
  rm -f ${INSTALLATION_NAME}-trusted-entities.json
}

function create_policy {
  policy_arn=$(aws iam create-policy --policy-name $2 --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://$1-policy.json  | jq -r '.Policy.Arn')
  aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${policy_arn}"
}

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

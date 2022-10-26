# Cluster API AWS provider role
If you don't know what the `INSTALLATION_NAME` value is supposed to be, ask Giant Swarm staff and they will provide it.

## with aws cli
### requirements
- `awscli` installed 
- `envsubst` tool
- `jq` installed
- working AWS credentials set to the desired target account
- located on the `capa-controller-role` directory of this git repo
- user `${INSTALLATION}-capa-controller` created in GiantSwarm account `084190472784`

### commands to execute
```
export INSTALLATION_NAME=test
export ROLE_NAME="giantswarm-${INSTALLATION_NAME}-capa-controller"

envsubst < ./trusted-entities.json > ${INSTALLATION_NAME}-trusted-entities.json
aws iam create-role --role-name "${ROLE_NAME}" --description "Giant Swarm managed role for k8s cluster creation" --assume-role-policy-document file://${INSTALLATION_NAME}-trusted-entities.json
rm -f ${INSTALLATION_NAME}-trusted-entities.json

CAPA_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-capa-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://capa-controller-policy.json | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${CAPA_POLICY_ARN}"

DNS_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-dns-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://dns-controller-policy.json | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${DNS_POLICY_ARN}"

EKS_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-eks-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://eks-controller-policy.json | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${EKS_POLICY_ARN}"

IAM_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-iam-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://iam-controller-policy.json | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${IAM_POLICY_ARN}"

IRSA_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-irsa-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://irsa-operator-policy.json  | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${IRSA_POLICY_ARN}"

NETWORK_TOPOLOGY_POLICY_ARN=$(aws iam create-policy --policy-name "giantswarm-${INSTALLATION_NAME}-network-topology-controller-policy" --description "Giant Swarm managed policy for k8s cluster creation" --policy-document file://network-topology-operator-policy.json | jq -r '.Policy.Arn')
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${NETWORK_TOPOLOGY_POLICY_ARN}"

```

## with terraform
### requirements
- `terraform` installed
- working AWS credentials set to the desired target account
- AWS region has to be set  either via aws profile or via env `AWS_REGION`

### adjust `variables.tf` 
- `principal_arns_giantswarm_root_account` - can be adjusted to be more strict and specify user which will assume the role - ie `arn:aws:iam::084190472784:user/${INSTALLATION_NAME}-capa-controller`

### execute
```
terraform init .
terraform apply -var="installation_name=test"
```

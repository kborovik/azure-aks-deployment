#!/usr/bin/env bash

set -e

ENVIRONMENT=${1,,}
ARM_CLIENT_SECRET=${2:-$(pass azure/client_secret)}
ARM_CLIENT_ID=${3:-$(pass azure/client_id)}
ARM_SUBSCRIPTION_ID=${4:-$(pass azure/subscription_id)}
ARM_TENANT_ID=${5:-$(pass azure/tenant_id)}
ARM_RESOURCE_GROUP="aks-shared"
CHART_VERSION=${6:-"3.7.0"}

_usage() {
  echo
  echo "Usage: $(basename "$0") (DEV|STG|PRD)"
  echo

  exit 1
}

if [[ ! "${ENVIRONMENT}" =~ (dev|stg|prd) ]]; then
  _usage
fi

echo -e
az login --service-principal --tenant "${ARM_TENANT_ID}" --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --output table --only-show-errors
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

echo -e "\nGet AKS Credentials"
az aks get-credentials --resource-group "aks-${ENVIRONMENT}" --name "aks-${ENVIRONMENT}" --overwrite-existing

az logout

echo -e "\nDeploy Ingress Controller"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade external-dns bitnami/external-dns \
  --install \
  --version="${CHART_VERSION}" \
  --create-namespace \
  --namespace external-dns \
  --atomic \
  --wait \
  --timeout=2m \
  --set sources[0]=ingress \
  --set provider=azure \
  --set azure.tenantId="${ARM_TENANT_ID}" \
  --set azure.subscriptionId="${ARM_SUBSCRIPTION_ID}" \
  --set azure.resourceGroup="${ARM_RESOURCE_GROUP}" \
  --set azure.useManagedIdentityExtension=true

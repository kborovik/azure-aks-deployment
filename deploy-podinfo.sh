#!/usr/bin/env bash

set -e

ENVIRONMENT=${1,,}
ARM_CLIENT_SECRET=${2:-$(pass azure/client_secret)}
ARM_CLIENT_ID=${3:-$(pass azure/client_id)}
ARM_SUBSCRIPTION_ID=${4:-$(pass azure/subscription_id)}
ARM_TENANT_ID=${5:-$(pass azure/tenant_id)}

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

echo -e "\nDeploy Podinfo"
helm upgrade podinfo charts/podinfo \
  --install \
  --create-namespace \
  --namespace "default" \
  --atomic \
  --wait \
  --timeout=2m \
  --set ingress.hosts[0]="podinfo.${ENVIRONMENT}.lab5.ca"

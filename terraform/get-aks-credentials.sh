#!/usr/bin/env bash

ARM_TENANT_ID="${4:-$(pass azure/tenant_id)}"
ARM_SUBSCRIPTION_ID="${3:-$(pass azure/subscription_id)}"
ARM_CLIENT_ID="${2:-$(pass azure/client_id)}"
ARM_CLIENT_SECRET="${1:-$(pass azure/client_secret)}"
GIT_REF="$(git rev-parse --abbrev-ref HEAD)"

echo -e "\nAzure Login"
az login --service-principal --tenant "${ARM_TENANT_ID}" --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --output table
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

echo -e "\nGet AKS Credentials"
if [[ "${GIT_REF}" == "development" ]]; then
  az aks get-credentials --resource-group aks-dev --name aks-dev --overwrite-existing
elif [[ "${GIT_REF}" == "staging" ]]; then
  az aks get-credentials --resource-group aks-stg --name aks-stg --overwrite-existing
elif [[ "${GIT_REF}" == "production" ]]; then
  az aks get-credentials --resource-group aks-prd --name aks-prd --overwrite-existing
else
  echo -e "\nGit branch ${GIT_REF} is not part of the supported Git Flow"
fi

echo -e "\nAzure Logout"
az logout

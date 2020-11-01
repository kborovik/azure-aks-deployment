#!/usr/bin/env bash

#
# Microsoft ref: https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster
#

ENVIRONMENT=${1,,}
ACTION=${2,,}
ARM_CLIENT_SECRET="${3:-$(pass azure/client_secret)}"
ARM_CLIENT_ID="${4:-$(pass azure/client_id)}"
ARM_SUBSCRIPTION_ID="${5:-$(pass azure/subscription_id)}"
ARM_TENANT_ID="${6:-$(pass azure/tenant_id)}"

_usage() {
  echo
  echo "Usage: $(basename "$0") <(DEV|STG|PRD)> (start|stop|state)"
  echo

  exit 1
}

if [[ ! "${ENVIRONMENT}" =~ (dev|stg|prd) ]] || [[ ! "${ACTION}" =~ (start|stop|state) ]] || [[ -z "${ARM_CLIENT_SECRET}" ]]; then
  _usage
fi

echo -e
az login --service-principal --tenant "${ARM_TENANT_ID}" --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --output table --only-show-errors
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

if [[ "${ACTION}" == "stop" ]]; then
  echo -e "\nStop AKS Cluster"
  az aks stop --resource-group "aks-${ENVIRONMENT}" --name "aks-${ENVIRONMENT}"
fi

if [[ "${ACTION}" == "start" ]]; then
  echo -e "\nStart AKS Cluster"
  az aks start --resource-group "aks-${ENVIRONMENT}" --name "aks-${ENVIRONMENT}"
fi

if [[ "${ACTION}" == "state" ]]; then
  echo -e "\nAKS Power State"
  az aks show --resource-group "aks-${ENVIRONMENT}" --name "aks-${ENVIRONMENT}" --output tsv --only-show-errors --query 'agentPoolProfiles[0].powerState.code'
fi

az logout

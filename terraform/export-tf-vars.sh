#!/usr/bin/env bash

ARM_TENANT_ID="$(pass azure/tenant_id)"
ARM_SUBSCRIPTION_ID="$(pass azure/subscription_id)"
ARM_CLIENT_ID="$(pass azure/client_id)"
ARM_CLIENT_SECRET="$(pass azure/client_secret)"

echo -e "\nAzure Login"
az login --service-principal --tenant "${ARM_TENANT_ID}" --username "${ARM_CLIENT_ID}" --password "${ARM_CLIENT_SECRET}" --output table
az account set --subscription "${ARM_SUBSCRIPTION_ID}"

export ARM_TENANT_ID
export ARM_SUBSCRIPTION_ID
export ARM_CLIENT_ID
export ARM_CLIENT_SECRET

export TF_VAR_tenant_id=${ARM_TENANT_ID}
export TF_VAR_subscription_id=${ARM_SUBSCRIPTION_ID}
export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}

echo -e "\nAzure Logout"
az logout 

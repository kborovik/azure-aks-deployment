#!/usr/bin/env bash

set -e

# Terraform Ref: https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

export ARM_TENANT_ID=${5:-"$(pass azure/tenant_id)"}
export ARM_SUBSCRIPTION_ID=${4:-"$(pass azure/subscription_id)"}
export ARM_CLIENT_ID=${3:-"$(pass azure/client_id)"}
export ARM_CLIENT_SECRET=${2:-"$(pass azure/client_secret)"}

export TF_VAR_environment=${1,,}
export TF_VAR_tenant_id=${ARM_TENANT_ID}
export TF_VAR_subscription_id=${ARM_SUBSCRIPTION_ID}
export TF_VAR_client_id=${ARM_CLIENT_ID}
export TF_VAR_client_secret=${ARM_CLIENT_SECRET}

_usage() {
    echo
    echo "Usage: $(basename "$0") <(dev|stg|prd)> <ARM_CLIENT_SECRET> <ARM_CLIENT_ID> <ARM_SUBSCRIPTION_ID> <ARM_TENANT_ID>"
    echo

    exit 1
}

if [[ -z "${ARM_CLIENT_SECRET}" ]] || [[ ! "${TF_VAR_environment}" =~ (dev|stg|prd) ]]; then
    _usage
fi

echo
echo "ARM_TENANT_ID         ${ARM_TENANT_ID}"
echo "ARM_SUBSCRIPTION_ID   ${ARM_SUBSCRIPTION_ID}"
echo "ARM_CLIENT_ID         ${ARM_CLIENT_ID}"

cd terraform

echo -e "\nRunning Terraform Fmt..."
terraform fmt -check -no-color

echo -e "\nRunning Terraform Init..."
terraform init -backend-config="backend-${TF_VAR_environment}.tfvars" -no-color

echo -e "\nRunning Terraform Validate..."
terraform validate -no-color

echo -e "\nRunning Terraform Apply..."
terraform apply -auto-approve -no-color

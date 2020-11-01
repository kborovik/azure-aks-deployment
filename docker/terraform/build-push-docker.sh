#!/usr/bin/env bash

set -e

DOCKER_SERVER="ghcr.io"
IMAGE_NAME="terraform-azure-cli"
DOCKER_USER="kborovik"
DOCKER_PASSWORD="${1:-$(pass github/docker_password)}"
DOCKER_TAG="${DOCKER_SERVER}/${DOCKER_USER}/${IMAGE_NAME}"
TERRAFORM_VERSION="$(grep -e '^ARG TERRAFORM_VERSION' Dockerfile | cut -d "=" -f 2)"

_usage() {
  echo
  echo "Usage: $(basename "$0") <DOCKER_PASSWORD>"
  exit 1
}

if [[ -z "${DOCKER_PASSWORD}" ]]; then
  _usage
fi

docker build --tag="${DOCKER_TAG}:${TERRAFORM_VERSION}" --file="Dockerfile" .

docker tag "${DOCKER_TAG}:${TERRAFORM_VERSION}" "${DOCKER_TAG}:latest"

docker login --username "${DOCKER_USER}" --password "${DOCKER_PASSWORD}" "${DOCKER_SERVER}"

docker push "${DOCKER_TAG}:${TERRAFORM_VERSION}"
docker push "${DOCKER_TAG}:latest"

docker logout "${DOCKER_SERVER}"

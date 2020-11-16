#!/usr/bin/env bash

# set -e

DOCKER_SERVER="ghcr.io"
DOCKER_USER="kborovik"
IMAGE_NAME="wrk2"
DOCKER_PASSWORD="${1:-$(pass github/docker_password)}"
DOCKER_TAG="${DOCKER_SERVER}/${DOCKER_USER}/${IMAGE_NAME}"
REVISION="$(git rev-parse --short HEAD)"

_usage() {
  echo
  echo "Usage: $(basename "$0") <DOCKER_PASSWORD>"
  exit 1
}

if [[ -z "${DOCKER_PASSWORD}" ]]; then
  _usage
fi

docker build --tag="${DOCKER_TAG}:${REVISION}" --rm --file="Dockerfile" ../../src/wrk2/

docker tag "${DOCKER_TAG}:${REVISION}" "${DOCKER_TAG}:latest"

docker login --username "${DOCKER_USER}" --password "${DOCKER_PASSWORD}" "${DOCKER_SERVER}"

docker push "${DOCKER_TAG}:${REVISION}"
docker push "${DOCKER_TAG}:latest"

docker logout "${DOCKER_SERVER}"

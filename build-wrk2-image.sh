#!/usr/bin/env bash

set -e

DOCKER_SERVER="ghcr.io"
DOCKER_USER="kborovik"
IMAGE_NAME="wrk2"
DOCKER_PASSWORD="${1:-$(pass github/docker_password)}"
DOCKER_TAG="${DOCKER_SERVER}/${DOCKER_USER}/${IMAGE_NAME}"

_usage() {
  echo
  echo "Usage: $(basename "$0") <DOCKER_PASSWORD>"
  exit 1
}

if [[ -z "${DOCKER_PASSWORD}" ]]; then
  _usage
fi

cd src/wrk2

REVISION="$(git rev-parse --short HEAD)"

docker build --tag="${DOCKER_TAG}:${REVISION}" --rm --file="../../docker/wrk2/Dockerfile" .

docker tag "${DOCKER_TAG}:${REVISION}" "${DOCKER_TAG}:latest"

docker login --username "${DOCKER_USER}" --password "${DOCKER_PASSWORD}" "${DOCKER_SERVER}"

docker push "${DOCKER_TAG}:${REVISION}"
docker push "${DOCKER_TAG}:latest"

docker logout "${DOCKER_SERVER}"

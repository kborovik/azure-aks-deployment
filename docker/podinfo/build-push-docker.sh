#!/usr/bin/env bash

set -e
DOCKER_SERVER="ghcr.io"
IMAGE_NAME="podinfo"
DOCKER_USER="kborovik"
DOCKER_PASSWORD="${1:-$(pass github/docker_password)}"
DOCKER_IMAGE_NAME="${DOCKER_SERVER}/${DOCKER_USER}/${IMAGE_NAME}"
VERSION="$(grep 'VERSION' ../../src/podinfo/pkg/version/version.go | cut -d '"' -f 2)"
REVISION="$(git rev-parse --short HEAD)"

_usage() {
  echo
  echo "Usage: $(basename "$0") <DOCKER_PASSWORD>"
  exit 1
}

if [[ -z "${DOCKER_PASSWORD}" ]]; then
  _usage
fi

docker build --tag="${DOCKER_IMAGE_NAME}:${VERSION}" --file="Dockerfile" ../../src/podinfo/

docker tag "${DOCKER_IMAGE_NAME}:${VERSION}" "${DOCKER_IMAGE_NAME}:${REVISION}"
docker tag "${DOCKER_IMAGE_NAME}:${VERSION}" "${DOCKER_IMAGE_NAME}:latest"

docker login --username "${DOCKER_USER}" --password "${DOCKER_PASSWORD}" "${DOCKER_SERVER}"

docker push "${DOCKER_IMAGE_NAME}:${VERSION}"
docker push "${DOCKER_IMAGE_NAME}:${REVISION}"
docker push "${DOCKER_IMAGE_NAME}:latest"

docker logout "${DOCKER_SERVER}"

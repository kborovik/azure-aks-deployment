#!/bin/env bash

set -e

RELEASE_NAME="podinfo"
INSTALL=true

_usage() {
  cat <<EOF

Usage: $(basename "$0") -i [-u] [-r <release_name>] [-d]

        [-i]                    # install HELM chart
        [-u]                    # uninstall HELM chart
        [-r <release_name>]     # set HELM chart release name (default: podinfo)
        [-d]                    # set HELM debug flags (--dry-run --debug)

EOF
  exit 1
}

_install() {

  echo -n -e "\n Getting Docker password from Pass..."
  DOCKER_PASSWORD="$(pass github/docker_password)"

  echo -e "\n Deploying HELM chart..."
  helm upgrade "${RELEASE_NAME}" ./podinfo ${DEBUG} ${DRY_RUN} \
    --install \
    --create-namespace \
    --namespace "default" \
    --atomic \
    --wait \
    --timeout=2m \
    --set image.password="${DOCKER_PASSWORD}"
}

_uninstall() {

  if ! helm uninstall --namespace "${RELEASE_NAME}" "${RELEASE_NAME}"; then
    helm list --all-namespaces
    echo -e "\n Try to use: $(basename "$0") -u -r <name_release>"
  fi
}

# Start main

if (($# == 0)); then
  _usage
fi

while getopts "ihudr:" OPT; do

  case ${OPT} in
  i)
    INSTALL=true
    ;;
  u)
    INSTALL=false
    ;;
  r)
    RELEASE_NAME=${OPTARG}
    ;;
  d)
    DEBUG="--debug"
    DRY_RUN="--dry-run"
    ;;
  ?)
    _usage
    ;;
  esac
done

if [[ "${INSTALL}" == "true" ]]; then
  _install
else
  _uninstall
fi

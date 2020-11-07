FROM ubuntu:20.04 as terraform

LABEL org.opencontainers.image.source https://github.com/kborovik/azure-aks-deployment

ARG TERRAFORM_VERSION=0.13.5
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg apt-utils

# Install Terraform cli
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
  && echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/terraform.list \
  && apt-get -y update \
  && apt-get -y install terraform=${TERRAFORM_VERSION}

# Install kubectl
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update \
  && apt-get -y install kubectl

# Install HELM
RUN curl -fsSL https://baltocdn.com/helm/signing.asc | apt-key add - \
  && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
  && apt-get update \
  && apt-get -y install helm

# Install Azure cli.
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update \
  && apt-get -y install azure-cli

WORKDIR /terraform

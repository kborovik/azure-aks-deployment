FROM ubuntu:20.04 as terraform

ARG TERRAFORM_VERSION=0.13.4
ENV DEBIAN_FRONTEND noninteractive

# Install Azure cli.
RUN apt-get -y update \
  && apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg apt-utils \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update \
  && apt-get -y install azure-cli

# Install Terraform cli
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
  && echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/terraform.list \
  && apt-get -y update \
  &&apt-get -y install terraform=${TERRAFORM_VERSION}

WORKDIR /terraform

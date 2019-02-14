#!/bin/bash

set -euo pipefail

export DOCKER_REPO=lwolf/helm-kubectl-docker
export K8S_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/kubernetes/kubernetes/releases/latest | cut -d '/' -f 8)
export HELM_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/helm/helm/releases/latest | cut -d '/' -f 8)

export RELEASE=${K8S_VERSION}-${HELM_VERSION}

docker manifest inspect ${DOCKER_REPO}:${RELEASE} > /dev/null && echo "Version ${RELEASE} is already exists" && exit 0

# Build image
docker build -t $DOCKER_REPO:${RELEASE} \
    --build-arg K8S_VERSION=${K8S_VERSION} \
    --build-arg HELM_VERSION=${HELM_VERSION} .

# Push image
docker push ${DOCKER_REPO}:${RELEASE}

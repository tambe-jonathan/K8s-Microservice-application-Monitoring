#!/usr/bin/env bash

set -euo pipefail

echo " Verifying environment..."

check() {
  if command -v "$1" >/dev/null 2>&1; then
    echo " $1 installed"
  else
    echo " $1 NOT installed"
    exit 1
  fi
}

check git
check docker
check kubectl
check minikube
check helm
check k6

echo " Checking Kubernetes cluster..."

if kubectl get nodes >/dev/null 2>&1; then
  echo " Cluster is accessible"
else
  echo " Cluster not accessible"
  exit 1
fi

echo " Environment looks good!"

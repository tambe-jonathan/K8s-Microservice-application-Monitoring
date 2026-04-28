#!/usr/bin/env bash

set -euo pipefail

echo " Starting Minikube cluster..."

PROFILE="monitoring-cluster"

if minikube status -p $PROFILE >/dev/null 2>&1; then
  echo " Minikube already running"
else
  minikube start \
    -p $PROFILE \
    --cpus=2 \
    --memory=3072 \
    --driver=docker
fi

echo " Enabling addons..."
minikube addons enable metrics-server -p $PROFILE

echo " Verifying cluster..."
kubectl get nodes

echo " Cluster ready!"

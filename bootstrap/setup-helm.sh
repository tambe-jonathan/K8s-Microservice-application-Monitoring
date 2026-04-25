#!/usr/bin/env bash

set -euo pipefail

echo " Setting up Helm repositories..."

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo update

echo " Helm repositories configured"

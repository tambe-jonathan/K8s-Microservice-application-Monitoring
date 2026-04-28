#!/usr/bin/env bash

set -euo pipefail

APP_DIR="app/sock-shop"
REPO_URL="https://github.com/microservices-demo/microservices-demo.git"

echo " Preparing Sock Shop app..."

# Step 1: Clone or update
if [ ! -d "$APP_DIR/source" ]; then
  git clone $REPO_URL $APP_DIR/source
else
  echo " Updating existing repo..."
  cd $APP_DIR/source && git pull && cd - >/dev/null
fi

# Step 2: Extract manifests
mkdir -p $APP_DIR/manifests

cp $APP_DIR/source/deploy/kubernetes/complete-demo.yaml \
   $APP_DIR/manifests/complete-demo.yaml

echo " Manifests prepared in app/sock-shop/manifests/"

# Step 3: Deploy
kubectl apply -f $APP_DIR/manifests/complete-demo.yaml

echo " Waiting for pods..."
kubectl wait --for=condition=ready pod --all -n sock-shop --timeout=300s || true

echo " Access the app:"
minikube service front-end -n sock-shop

echo " Deployment complete"

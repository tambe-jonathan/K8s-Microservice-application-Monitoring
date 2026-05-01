#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="monitoring"
RELEASE_NAME="monitoring"

echo "🚀 Starting Monitoring Stack Deployment..."

# ---------- Step 1: Create Namespace ----------
echo "📦 Creating namespace..."
kubectl create namespace $NAMESPACE || echo "Namespace already exists"

# ---------- Step 2: Add Helm Repo ----------
echo "📦 Setting up Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update >/dev/null

# ---------- Step 3: Deploy kube-prometheus-stack ----------
echo "📊 Deploying Prometheus + Grafana + Alertmanager..."

helm upgrade --install $RELEASE_NAME prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  -f monitoring/prometheus/values.yaml

echo "⏳ Waiting for monitoring pods to be ready..."
kubectl wait --for=condition=ready pod --all -n $NAMESPACE --timeout=300s || true

# ---------- Step 4: Apply Custom Alert Rules ----------
echo "🚨 Applying custom alert rules..."
kubectl apply -f monitoring/prometheus/custom-rules.yaml

# ---------- Step 5: Create Grafana Dashboards ConfigMap ----------
echo "📊 Loading Grafana dashboards..."

kubectl create configmap grafana-dashboards \
  --from-file=monitoring/grafana/dashboards \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# ---------- Step 6: Create Grafana Datasource Config ----------
echo " Configuring Grafana datasource..."

kubectl create configmap grafana-datasources \
  --from-file=monitoring/grafana/datasources.yaml \
  -n $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# ---------- Step 7: Restart Grafana to Load Config ----------
echo " Restarting Grafana to apply configs..."
kubectl rollout restart deployment ${RELEASE_NAME}-grafana -n $NAMESPACE

# ---------- Step 8: Verify Services ----------
echo " Verifying services..."

kubectl get pods -n $NAMESPACE
kubectl get svc -n $NAMESPACE

echo ""
echo " To access Grafana run:"
echo "kubectl port-forward svc/${RELEASE_NAME}-grafana 3000:80 -n $NAMESPACE"

echo ""
echo " Get Grafana password:"
echo "kubectl get secret ${RELEASE_NAME}-grafana -n $NAMESPACE -o jsonpath=\"{.data.admin-password}\" | base64 --decode"

echo ""
echo " Monitoring stack deployed successfully!"

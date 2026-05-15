
# Kubernetes Observability Platform with Prometheus & Grafana

A production-style Kubernetes observability project designed to monitor a microservices application using Prometheus, Grafana, Alertmanager, kube-state-metrics, and Node Exporter.

The project demonstrates:
- Kubernetes monitoring
- Infrastructure observability
- Real-time alerting
- Dashboard visualization
- Load testing & validation
- Monitoring automation with Helm

---

# 📊 Architecture

Components used:

- Prometheus
- Grafana
- Alertmanager
- kube-state-metrics
- Node Exporter
- Online Boutique microservices application
- k6 load testing

---

# 📁 Project Structure

```bash
.
├── bootstrap/
├── app/
├── monitoring/
├── operations/
├── load-testing/
├── docs/
└── experiments/
```

---

# 🚀 Prerequisites

Install:
- Docker
- kubectl
- Helm
- Minikube
- Git

Automated installation:

```bash
bash bootstrap/install-tools.sh
```

---

# ⚙️ Start Kubernetes Cluster

```bash
bash bootstrap/start-cluster.sh
```

Verify cluster:

```bash
kubectl get nodes
```

---

# 🛍️ Deploy Online Boutique Application

```bash
bash operations/deploy-app.sh
```

Verify deployment:

```bash
kubectl get pods -n boutique
```

---

# 📊 Deploy Monitoring Stack

This project uses the kube-prometheus-stack Helm chart.

Deploy monitoring stack:

```bash
bash operations/deploy-monitoring.sh
```

This deploys:
- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- kube-state-metrics

---

# 🌐 Access Grafana

```bash
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

Open:

```bash
http://localhost:3000
```

---

# 🔐 Grafana Credentials

Get password:

```bash
kubectl get secret monitoring-grafana -n monitoring \
-o jsonpath="{.data.admin-password}" | base64 --decode
```

Username:

```bash
admin
```

---

# 📈 Dashboards

Included dashboards:
- Cluster Health
- Application Metrics
- Traffic & Load Analysis

Dashboard files:

```bash
monitoring/grafana/dashboards/
```

---

# 🚨 Alert Rules

Custom Prometheus alert rules monitor:
- High CPU usage
- High memory utilization
- Pod restart loops
- Pod failures
- Network traffic spikes

Rules location:

```bash
monitoring/prometheus/custom-rules.yaml
```

Apply rules:

```bash
kubectl apply -f monitoring/prometheus/custom-rules.yaml
```

---

# ⚡ Load Testing

Generate traffic:

```bash
k6 run load-testing/k6-script.js
```

Stress test:

```bash
k6 run load-testing/scenarios/stress-test.js
```

---

# 🧪 Validation

Simulate pod failure:

```bash
kubectl delete pod <pod-name> -n boutique
```

Expected results:
- Pod auto-recovers
- Alerts trigger
- Metrics appear in Grafana

---

# 📚 Key Learning Outcomes

- Kubernetes observability
- Prometheus monitoring
- Grafana dashboarding
- Alerting strategies
- Infrastructure troubleshooting
- Monitoring automation
- SRE monitoring principles

---

# 📌 Future Improvements

- Slack alert integration
- Distributed tracing with Jaeger
- Loki log aggregation
- Deployment on AWS EKS

---

# 👨‍💻 Author

Agbor Jonathan Tambe  
Boogeyman Labs

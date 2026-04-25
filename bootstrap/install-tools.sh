#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo " Starting environment setup..."

# ---------- Helpers ----------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

OS="$(uname -s)"

echo " Detected OS: $OS"

# ---------- Install Git ----------
install_git() {
  if command_exists git; then
    echo " Git already installed: $(git --version)"
  else
    echo " Installing Git..."
    sudo apt-get update -y
    sudo apt-get install -y git
    echo " Git installed"
  fi
}

# ---------- Install kubectl ----------
install_kubectl() {
  if command_exists kubectl; then
    echo " kubectl already installed: $(kubectl version --client --short)"
  else
    echo " Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    echo " kubectl installed"
  fi
}

# ---------- Install Minikube ----------
install_minikube() {
  if command_exists minikube; then
    echo " Minikube already installed: $(minikube version)"
  else
    echo " Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    echo " Minikube installed"
  fi
}

# ---------- Install Helm ----------
install_helm() {
  if command_exists helm; then
    echo " Helm already installed: $(helm version --short)"
  else
    echo " Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo " Helm installed"
  fi
}

# ---------- Install Docker (Required for Minikube driver) ----------
install_docker() {
  if command_exists docker; then
    echo " Docker already installed: $(docker --version)"
  else
    echo " Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker "$USER"
    echo " You may need to log out and back in for Docker permissions"
    echo " Docker installed"
  fi
}

# ---------- Run Installations ----------
install_git
install_docker
install_kubectl
install_minikube
install_helm

echo "🎯 All tools installed successfully!"

#!/usr/bin/env bash

set -euo pipefail

if command -v k6 >/dev/null 2>&1; then
  echo " k6 already installed"
else
  echo " Installing k6..."

  sudo apt-get update -y
  sudo apt-get install -y gnupg software-properties-common

  sudo gpg -k || true

  curl -s https://dl.k6.io/key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/k6-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | \
    sudo tee /etc/apt/sources.list.d/k6.list

  sudo apt-get update -y
  sudo apt-get install -y k6

  echo " k6 installed"
fi

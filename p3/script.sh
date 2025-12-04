#!/usr/bin/env zsh

YAML_FILE="manifests/config.yaml"

k3d cluster delete clusty
k3d cluster create clusty

# Install Argo CD in kubectl
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f "$YAML_FILE"

echo "Deployment complete."

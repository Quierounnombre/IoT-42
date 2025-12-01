#!/usr/bin/env zsh

YAML_FILE="config.yaml"

k3d cluster delete clusty
k3d cluster create clusty

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Install Argo CD in kubectl
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f "$YAML_FILE"

kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=800s

kubectl port-forward svc/argocd-server -n argocd 8080:443 &

echo "PASSWORD = " -n
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo "\n"

argocd cluster add dev

echo "Deployment complete."


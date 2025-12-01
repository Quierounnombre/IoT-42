#!/usr/bin/env zsh

YAML_FILE="config.yaml"

k3d cluster delete prueba
k3d cluster create prueba

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Install Argo CD in kubectl
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

kubectl apply -f "$YAML_FILE"
echo "Deployment complete."


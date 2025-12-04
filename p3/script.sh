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

kubectl rollout status deployment -n argocd --timeout=800s
kubectl rollout status deployment -n dev --timeout=800s

kubectl port-forward svc/argocd-server -n argocd 8080:443 &
kubectl port-forward svc/dev-net -n dev 8888:80 &

echo "PASSWORD---------------------------------"
ARGOCD_PSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "\n-----------------------------------------\n"

kubectl config set-context --current --namespace=argocd
argocd login localhost:8080 --username admin --password "$ARGOCD_PSWD" --insecure
argocd app create will-app \
  --repo https://github.com/Quierounnombre/IoT-42.git \
  --path manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --revision master \
  --sync-policy automated


echo "Deployment complete."


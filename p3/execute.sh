#!/usr/bin/env zsh

kubectl port-forward svc/argocd-server -n argocd 8080:443 &

echo "PASSWORD---------------------------------"
ARGOCD_PSWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "$ARGOCD_PSWD"
echo "\n-----------------------------------------\n"

kubectl config set-context --current --namespace=argocd
argocd login localhost:8080 \
	--username admin \
	--password "$ARGOCD_PSWD" \
	--insecure

argocd app create app \
  --repo https://github.com/Quierounnombre/IoT-42.git \
  --path p3/manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --revision master \
  --sync-policy automated \
  --auto-prune \
  --upsert \
  --self-heal \

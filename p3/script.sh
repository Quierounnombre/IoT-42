#!/usr/bin/env zsh

YAML_FILE="config.yaml"

kubectl delete -f "$YAML_FILE" --ignore-not-found
k3d cluster delete Prueba
k3d cluster create Prueba
kubectl apply -f "$YAML_FILE"

echo "Deployment complete."

x=1
while [ $x -le 5 ]
do
	echo "waiting $x seconds"
	sleep 1
	x=$(( $x + 1))
done

kubectl get all -o wide -n dev
kubectl get nodes -o wide -n dev

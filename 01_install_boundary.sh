#! /bin/bash
source helper.sh
# set -eu
# set -o pipefail

c1_kctx

echo ".:boundary:. Deploying postgreSQL backend"
kubectl apply -k ./manifests/postgres
echo ".:boundary:. Waiting on postgreSQL backend"
kubectl wait --for=condition=available --timeout=5m --namespace=postgres deployment.apps/postgres

echo ".:boundary:. Deploying boundary server"
kubectl apply -k ./manifests/boundary
echo ".:boundary:. Waiting on boundary server"
kubectl wait --for=condition=available --timeout=5m --namespace=boundary deployment.apps/boundary

minikube tunnel --cleanup=true -p cluster-1&
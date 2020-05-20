#!/usr/bin/env bash

set -e

k8s_dir=k8s
kubeconfig_path=$k8s_dir/.config/kubeconfig.yaml

kubectl_flags="--kubeconfig=$kubeconfig_path"
kubectl="kubectl $kubectl_flags"

# apply manifests
echo "running: $kubectl -f $k8s_dir"
kubectl "$kubectl_flags" apply -f $k8s_dir

# print services
kubectl "$kubectl_flags" get svc -o wide

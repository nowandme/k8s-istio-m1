#!/bin/zsh
set -e

kind create cluster --config=single-node.yaml

# add config
kind get kubeconfig > $HOME/.kube/config

# Calico
curl https://docs.projectcalico.org/manifests/calico.yaml | kubectl apply -f -

# CoreDNS
kubectl scale deployment --replicas 1 coredns --namespace kube-system

# istio
istioctl install -f ./install-istio.yaml -y

kubectl label namespace default istio-injection=enabled --overwrite

# cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml

#!/bin/bash

# Enter password as arg 1, otherwise will be assigned blank password
K8USERPASSWORD=$1

# Starts setup of Control Node. Creates Pod Network to use
kubeadm init --pod-network-cidr=192.168.0.0/16

# Create User to administrate with kubectl
useradd k8user
usermod -aG wheel k8user
echo $K8USERPASSWORD | passwd k8user --stdin
K8HOME=/home/k8user
mkdir -p ${K8HOME}/.kube
cp -i /etc/kubernetes/admin.conf ${K8HOME}/.kube/config
chown k8user:k8user ${K8HOME}/.kube/config

# Install Calico
su - k8user -c "kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml"
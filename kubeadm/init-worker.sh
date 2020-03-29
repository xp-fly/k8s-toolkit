#!/bin/bash

# 修改变量
MASTER_IP=192.168.199.100
WORKER_IP=192.168.199.101
APISERVER_NAME=k8s-master
WORKER_NAME=k8s-worker1

hostnamectl set-hostname $WORKER_NAME
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts

## master执行 kubeadm token create --print-join-command 获取 token 和 hash
TOKEN=xxxx
SHA_HASH=xxxx

kubeadm join ${APISERVER_NAME}:6443 --token ${TOKEN}  --discovery-token-ca-cert-hash ${SHA_HASH}

# 复制master的ip到worker节点上
rm -rf /root/.kube/
mkdir /root/.kube/
cp root@$APISERVER_NAME:/etc/kubernetes/admin.conf /root/.kube/config

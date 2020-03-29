#!/bin/bash

# 修改变量
MASTER_IP=192.168.199.101
export APISERVER_NAME=k8s-master
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts
## master执行 kubeadm token create --print-join-command 获取 token 和 hash
TOKEN=xxxx
SHA_HASH=xxxx


kubeadm join ${APISERVER_NAME}:6443 --token ${TOKEN}  --discovery-token-ca-cert-hash ${SHA_HASH}

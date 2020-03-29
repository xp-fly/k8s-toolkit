#!/bin/bash

set -e

## 修改变量
k8s_version=v1.17.4
host=192.168.199.
# Kubernetes 容器组所在的网段，该网段安装完成后，由 kubernetes 创建，事先并不存在于您的物理网络中
pod_subnet=10.100.0.1/16
apiserver_name=k8s-master

## 修改host
hostnamectl set-hostname $apiserver_name
# 设置 hostname 解析
echo "$host   $apiserver_name" >> /etc/hosts


## 查看完整配置选项 https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2
rm -f ./kubeadm-config.yaml
cat <<EOF > ./kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: $k8s_version
imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
controlPlaneEndpoint: "$apiserver_name:6443"
networking:
  serviceSubnet: "10.96.0.0/16"
  podSubnet: "$pod_subnet"
  dnsDomain: "cluster.local"
EOF

# kubeadm init
# 根据您服务器网速的情况，您需要等候 3 - 10 分钟
kubeadm init --config=kubeadm-config.yaml --upload-certs

# 配置 kubectl
rm -rf /root/.kube/
mkdir /root/.kube/
cp -i /etc/kubernetes/admin.conf /root/.kube/config

# 安装 calico 网络插件
# 参考文档 https://docs.projectcalico.org/v3.13/getting-started/kubernetes/self-managed-onprem/onpremises
echo "安装calico-3.13.1"
rm -f calico-3.13.1.yaml
wget https://kuboard.cn/install-script/calico/calico-3.13.1.yaml
kubectl apply -f calico-3.13.1.yaml
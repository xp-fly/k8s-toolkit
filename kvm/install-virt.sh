#!/bin/bash

## 安装虚拟机脚本 
## cp example.cfg 192.168.199.101.cfg
## 修改 192.168.199.101.cfg 文件中的ip为192.168.199.101
## sh install-virt.sh 192.168.199.101

set -ex

## 修改的变量
httpd_uri=http://192.168.199.110:8081
gateway=192.168.199.1
## =========

mkdir -p /data/kvm/data/${1}

virt-install \
--autostart \
--accelerate \
-n ${1} \
--disk path=/data/kvm/data/${1}/${1}.img,format=qcow2,bus=virtio,size=15 \
--network bridge=br0 \
-r 8192 \
--vcpus=6 \
--os-type=linux \
--os-variant=rhel7.0 \
--nographics \
-l http://$httpd_uri/centos7/ \
-x "ks=$httpd_uri/${1}.cfg console=ttyS0 –device=eth0 ip=${1} netmask=255.255.255.0 gateway=$gateway ksdevice=eth0"
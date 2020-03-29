#!/bin/bash

## 安装 kvm 所需依赖

## -x 打印命令 -e 发生错误，脚本终止
set -ex

## 需要修改的变量
enps_name=enps30
host=192.168.8.100
gateway=192.168.8.1

## 安装 kvm 相关依赖
yum -y install qemu-kvm qemu-img libvirt virt-install libvirt-client

## 启动 libvirt 并且设置为默认启动
systemctl start libvirtd
systemctl enable libvirtd
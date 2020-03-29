#/bin/bash

set -ex

yum -y install httpd

sed -i 's/port:80/port:8081/g' /etc/httpd/conf/httpd.conf

systemctl start httpd 
systemctl enable httpd

## 本机镜像源
mkdir -p /data/kvm/data
mkdir -p /data/kvm/iso

if [ ! -f /data/kvm/iso/CentOS-7-x86_64-Minimal-1908.iso ]; then
    wget -O /data/kvm/iso/CentOS-7-x86_64-Minimal-1908.iso https://mirrors.aliyun.com/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso
fi

## 创建目录并挂载镜像文件
mkdir -p /var/www/html/centos7
mount -o loop /var/www/html/centos7/ /data/kvm/iso/CentOS-7-x86_64-Minimal-1908.iso

## 关闭防火墙
systemctl stop firewall

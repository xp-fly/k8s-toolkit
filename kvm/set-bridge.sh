#!/bin/bash

## 设置属主机网桥上网

set -ex

## 创建网桥设备
cp /etc/sysconfig/network-scripts/ifcfg-$enps_name /etc/sysconfig/network-scripts/ifcfg-br0

## 修改ifcfg-br0文件
sed -i 's/"//g'
sed -i 's/TYPE=Ethernet/TYPE=Bridge/g' /etc/sysconfig/network-scripts/ifcfg-br0
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/g' /etc/sysconfig/network-scripts/ifcfg-br0
sed -i "s/NAME=$enps_name/NAME=br0/g" /etc/sysconfig/network-scripts/ifcfg-br0
sed -e '/UUID/d;/IPV6/d' /etc/sysconfig/network-scripts/ifcfg-br0  > /etc/sysconfig/network-scripts/ifcfg-br0
sed "\$aIPADDR=$host" /etc/sysconfig/network-scripts/ifcfg-br0
sed '$aPREFIX=24' /etc/sysconfig/network-scripts/ifcfg-br0
sed "\$aGATEWAY=$gateway" /etc/sysconfig/network-scripts/ifcfg-br0

## 修改 ifcfg-enps30 文件
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/g' /etc/sysconfig/network-scripts/ifcfg-$enps_name
sed '$aBRIDGE=br0' /etc/sysconfig/network-scripts/ifcfg-br0

## 重启网络
nmcli c reload
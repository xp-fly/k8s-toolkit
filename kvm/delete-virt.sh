#!/bin/bash

virsh destroy $1
virsh undefine $1
rm -rf /data/kvm/data/${1}/${1}.img
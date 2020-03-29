#!/bin/bash

is_support=`cat /proc/cpuinfo | grep "vmx|svm"`

if [ -n $is_support ]; then
    echo "support kvm"
else
    echo "does not support kvm"
fi
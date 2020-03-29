#!/bin/bash

# 修改变量
MIRROR_URL=http://hub-mirror.c.163.com
DOCKER_DAEMON_JSON_FILE="/etc/docker/daemon.json"

# 卸载旧版本
yum remove -y docker \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-selinux \
docker-engine-selinux \
docker-engine

# 设置 yum repository
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装并启动 docker
yum install -y docker-ce-19.03.8 docker-ce-cli-19.03.8 containerd.io

# 修改docker镜像源
if test -f ${DOCKER_DAEMON_JSON_FILE}
then
    cp  ${DOCKER_DAEMON_JSON_FILE} "${DOCKER_DAEMON_JSON_FILE}.bak"
    if grep -q registry-mirrors "${DOCKER_DAEMON_JSON_FILE}.bak";then
        cat "${DOCKER_DAEMON_JSON_FILE}.bak" | sed -n "1h;1"'!'"H;\${g;s|\"registry-mirrors\":\s*\[[^]]*\]|\"registry-mirrors\": [\"${MIRROR_URL}\"]|g;p;}" | tee ${DOCKER_DAEMON_JSON_FILE}
    else
        cat "${DOCKER_DAEMON_JSON_FILE}.bak" | sed -n "s|{|{\"registry-mirrors\": [\"${MIRROR_URL}\"],|g;p;" | tee ${DOCKER_DAEMON_JSON_FILE}
    fi
else
    mkdir -p "/etc/docker"
    echo "{\"registry-mirrors\": [\"${MIRROR_URL}\"]}" | tee ${DOCKER_DAEMON_JSON_FILE}
fi

# 启动docker
systemctl enable docker
systemctl start docker


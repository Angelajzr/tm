#!/bin/bash

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，正在安装 Docker..."
    # 使用 curl 命令安装 Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "Docker 安装完成"
    sudo rm get-docker.sh
else
    echo "Docker 已安装"
fi

# 检查 Docker 是否正在运行
if ! sudo docker info &> /dev/null
then
    echo "Docker 未运行，正在启动 Docker 守护程序..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker 守护程序已启动"
else
    echo "Docker 正在运行"
fi

# 检查是否已安装 traffmonetizer/cli 容器
if sudo docker container ls --all --filter "name=tm" | grep -q "tm"; then
    echo "traffmonetizer/cli 容器已安装"
    exit 0
fi

# 检查架构
ARCH=$(uname -m)

# 根据架构选择正确的 Docker 镜像
if [ "$ARCH" = "x86_64" ]; then
    IMAGE="traffmonetizer/cli"
elif [ "$ARCH" = "aarch64" ]; then
    IMAGE="traffmonetizer/cli:arm64v8"
else
    echo "不支持的架构: $ARCH"
    exit 1
fi

# 使用给定的 Token
TOKEN="/0ubw6xvVoesgDXhfBgS4adxHTMu0W9sp7GiP2HV2mU="

# 部署 Docker 容器
sudo docker run -d --restart=always --name tm $IMAGE start accept --token $TOKEN

echo "部署完成"

#!/bin/bash

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，请先安装 Docker"
    exit 1
else
    echo "Docker 已安装"
fi

# 检查 Docker 是否正在运行
if ! docker info &> /dev/null
then
    echo "Docker 未运行，请确保 Docker 守护程序已启动"
    exit 1
else
    echo "Docker 正在运行"
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
TOKEN="jIfj6fgOGLR4dE18xBjzhlbjIuuTG3KlrcxK/am/INg="

# 部署 Docker 容器
docker run -d --restart=always --name tm $IMAGE start accept --token $TOKEN

echo "部署完成"
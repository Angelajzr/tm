#!/bin/bash

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，无需卸载容器"
    exit 1
else
    echo "Docker 已安装"
fi

# 检查 Docker 是否正在运行
if ! docker info &> /dev/null
then
    echo "Docker 未运行，无需卸载容器"
    exit 1
else
    echo "Docker 正在运行"
fi

# 停止并删除 tm 容器
if docker ps -a | grep -q "tm"
then
    echo "正在停止并删除 tm 容器..."
    docker stop tm
    docker rm tm
    echo "已成功卸载 tm 容器"
else
    echo "tm 容器不存在，无需卸载"
fi
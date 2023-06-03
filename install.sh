#!/bin/bash

# 检查 Docker 是否已安装
if ! command -v docker &> /dev/null
then
    echo "Docker 未安装，正在安装 Docker..."
    # 为不同的 Linux 发行版安装 Docker
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            ubuntu|debian)
                sudo apt-get update
                sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io
                ;;
            centos|rhel|fedora)
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                sudo yum install -y docker-ce docker-ce-cli containerd.io
                ;;
            *)
                echo "不支持的 Linux 发行版: $ID"
                exit 1
                ;;
        esac
    else
        echo "无法检测到操作系统类型。请手动安装 Docker。"
        exit 1
    fi
    echo "Docker 安装完成"
else
    echo "Docker 已安装"
fi

# 检查 Docker 是否正在运行
if ! docker info &> /dev/null
then
    echo "Docker 未运行，正在启动 Docker 守护程序..."
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker 守护程序已启动"
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

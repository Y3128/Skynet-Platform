#!/bin/bash

set -e 

echo "【天网平台】正在初始化本地环境..."

# === 安装 Git ===
if ! command -v git &> /dev/null; then   
    echo "正在安装 Git..."    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then    
        sudo dnf install -y git
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "请在 macOS 上运行 'xcode-select --install' 来安装 Git。"
        exit 1
    fi
fi

# === 安装 Python3 和 pip (Ansible 依赖) ===
if ! command -v python3 &> /dev/null; then
    echo "正在安装 Python3..."
    sudo dnf install -y python3 python3-pip
fi

# === 安装 Ansible ===
if ! command -v ansible &> /dev/null; then
    echo "正在安装 Ansible..."
    pip3 install --user ansible
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi

# === 安装 kubectl (Kubernetes CLI) ===
if ! command -v kubectl &> /dev/null; then
    echo "正在安装 kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

# === 安装 Helm (Kubernetes 包管理器) ===
if ! command -v helm &> /dev/null; then
    echo "正在安装 Helm..."
    if curl -fsSL https://mirrors.ustc.edu.cn/helm/install-helm.sh | bash; then
        echo "Helm 已通过中科大镜像成功安装。"
    else
        echo "镜像源安装失败，尝试官方源..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
fi

echo "【天网平台】本地环境初始化完成！"

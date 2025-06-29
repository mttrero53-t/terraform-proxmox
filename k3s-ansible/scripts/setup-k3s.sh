#!/bin/bash

# K3s クラスター構築スクリプト
set -e

echo "=== K3s クラスター構築開始 ==="

# 1. インベントリファイルの存在確認
if [ ! -f "inventory/hosts.yml" ]; then
    echo "Error: inventory/hosts.yml が見つかりません"
    exit 1
fi

# 2. SSH接続テスト
echo "SSH接続テスト中..."
ansible all -m ping

# 3. コントロールプレーンノードの構築
echo "コントロールプレーンノードを構築中..."
ansible-playbook playbooks/k3s-control-plane.yml

# 4. ワーカーノードの構築
echo "ワーカーノードを構築中..."
ansible-playbook playbooks/k3s-workers.yml

# 5. クラスター状態の確認
echo "クラスター状態確認中..."
ansible control_plane -m shell -a "k3s kubectl get nodes -o wide"

echo "=== K3s クラスター構築完了 ==="
echo ""
echo "kubeconfigファイルの場所: /home/ubuntu/.kube/config"
echo "クラスターにアクセスするには:"
echo "  ssh ubuntu@192.168.0.12"
echo "  kubectl get nodes"
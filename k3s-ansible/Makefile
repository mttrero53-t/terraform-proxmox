.PHONY: all ping setup-control-plane setup-workers verify clean

INVENTORY = inventory/hosts.yml

all: setup-control-plane setup-workers verify

ping:
	ansible all -m ping

setup-control-plane:
	ansible-playbook playbooks/k3s-control-plane.yml

setup-workers:
	ansible-playbook playbooks/k3s-workers.yml

verify:
	ansible control_plane -m shell -a "k3s kubectl get nodes -o wide"
	ansible control_plane -m shell -a "k3s kubectl get pods --all-namespaces"

clean:
	ansible all -m shell -a "sudo /usr/local/bin/k3s-uninstall.sh" -i inventory/hosts.yml || true
	ansible workers -m shell -a "sudo /usr/local/bin/k3s-agent-uninstall.sh" -i inventory/hosts.yml || true

kubeconfig:
	scp ubuntu@192.168.0.12:/home/ubuntu/.kube/config ./kubeconfig
	@echo "kubeconfigファイルをローカルに保存しました: ./kubeconfig"
	@echo "使用方法: export KUBECONFIG=./kubeconfig"

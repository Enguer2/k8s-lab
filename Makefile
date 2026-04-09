CLUSTER_NAME := k8s-lab

.PHONY: up down status

up:
	@echo "Create kubernetes Cluster"
	kind create cluster --name $(CLUSTER_NAME) --config kind-config.yaml
	@echo "Cluster Ready"
	kubectl cluster-info --context kind-$(CLUSTER_NAME)

down:
	@echo "Cluster Remove"
	kind delete cluster --name $(CLUSTER_NAME)
	@echo "Cluster Removed"

status:
	kubectl get nodes -o wide

install-monitoring:
	@echo "Installing Prometheus & Grafana"
	helm install prometheus prometheus-community/kube-prometheus-stack \
		--set grafana.service.type=NodePort \
		--set grafana.service.nodePort=30090 \
		--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
		--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
	@echo "Attente du déploiement"

install-chaos:
	@echo "Installing Chaos Mesh"
	kubectl create namespace chaos-mesh || true
	helm install chaos-mesh chaos-mesh/chaos-mesh \
		--namespace=chaos-mesh \
		--set dashboard.create=true \
		--set dashboard.service.type=NodePort \
		--set dashboard.service.nodePort=30100
	@echo "Chaos Mesh Ready http://localhost:30100"
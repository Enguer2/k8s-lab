CLUSTER_NAME := k8s-lab

.PHONY: up down status

up:
	@echo "🚀 Création du cluster Kubernetes local..."
	kind create cluster --name $(CLUSTER_NAME) --config kind-config.yaml
	@echo "✅ Cluster prêt ! Voici le contexte :"
	kubectl cluster-info --context kind-$(CLUSTER_NAME)

down:
	@echo "🗑️ Destruction du cluster..."
	kind delete cluster --name $(CLUSTER_NAME)
	@echo "🧹 Cluster supprimé."

status:
	kubectl get nodes -o wide

install-monitoring:
	@echo "🔍 Installation de la stack d'Observabilité (Prometheus/Grafana)..."
	helm install prometheus prometheus-community/kube-prometheus-stack \
		--set grafana.service.type=NodePort \
		--set grafana.service.nodePort=30090 \
		--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
		--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
	@echo "⏳ Attente du déploiement (ça peut prendre 1-2 minutes)..."

install-chaos:
	@echo "🔥 Installation de Chaos Mesh..."
	kubectl create namespace chaos-mesh || true
	helm install chaos-mesh chaos-mesh/chaos-mesh \
		--namespace=chaos-mesh \
		--set dashboard.create=true \
		--set dashboard.service.type=NodePort \
		--set dashboard.service.nodePort=30100
	@echo "✅ Chaos Mesh installé sur http://localhost:30100"
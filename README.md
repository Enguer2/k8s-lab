# 🛡️ k8s-lab : Arène de Chaos et Observabilité

> Laboratoire DevOps/SRE complet pour démontrer la mise en place d'une infrastructure résiliente, supervisée et testée contre les pannes (**Chaos Engineering**) sur Kubernetes.

---

## 🎯 Objectifs du Projet

| Pilier | Description |
|---|---|
| 🏗️ **Infrastructure as Code** | Déploiement automatisé d'un cluster K8s local avec Kind |
| 🔁 **Haute Disponibilité** | Stratégies de réplication et sondes de santé (Probes) |
| 👁️ **Observabilité** | Stack Prometheus/Grafana pour surveiller les SLO |
| 💥 **Chaos Engineering** | Simulation de pannes réelles pour tester l'auto-healing |

---

## 🛠️ Stack Technique

| Couche | Outil |
|---|---|
| **Orchestration** | Kubernetes via [Kind](https://kind.sigs.k8s.io/) |
| **Automatisation** | Makefile, Helm |
| **Observabilité** | Prometheus, Grafana |
| **Chaos** | [Chaos Mesh](https://chaos-mesh.org/) |
| **Application cobaye** | Nginx |

---

## 🚀 Roadmap

### ✅ Phase 1 — Fondations

- [x] Configuration du cluster Kind avec mapping de ports
- [x] Déploiement de l'application cobaye avec réplication (2 pods)
- [x] Configuration des Liveness et Readiness Probes

### ✅ Phase 2 — Les Yeux (Observabilité)

- [x] Installation de Prometheus via Helm
- [x] Configuration de Grafana et accès au dashboard de ressources Kubernetes
- [x] Vérification de la remontée des métriques des pods cobayes

### ✅ Phase 3 — L'Attaque (Chaos Engineering)

- [x] Installation de Chaos Mesh via Helm
- [x] Sécurisation de l'accès au Dashboard via RBAC et Tokens K8s
- [x] Création d'expériences de "Pod Kill" cycliques
- [x] Test et validation visuelle de l'auto-healing sous stress

---

## 📖 Guide d'utilisation (Cheat Sheet)

Les commandes pour lancer le laboratoire de A à Z.

### 🏗️ 1. Démarrage du Cluster et de l'Application

```bash
# 1. Créer le cluster Kubernetes local (Kind)
make up

# 2. Déployer l'application Nginx ("Les Cobayes")
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# 3. Vérifier que les pods tournent
kubectl get pods -w
```

---

### 👁️ 2. Déploiement du Monitoring (Prometheus & Grafana)

```bash
# 1. Installer la stack d'observabilité
make install-monitoring

# 2. (Optionnel) Si localhost:30090 ne répond pas après redémarrage, ouvrir un tunnel :
kubectl port-forward svc/prometheus-grafana 30090:80
```

> **Accès Grafana :** [http://localhost:30090](http://localhost:30090)
> **Identifiants :** `admin` / `prom-operator`

---

### 🔥 3. Déploiement de Chaos Mesh

```bash
# 1. Installer le moteur de Chaos
make install-chaos

# 2. Ouvrir l'accès au Dashboard (à laisser tourner dans un terminal dédié)
kubectl port-forward -n chaos-mesh svc/chaos-dashboard 30100:2333
```

> **Accès Chaos Mesh :** [http://localhost:30100](http://localhost:30100)

#### 🔑 Génération du Token pour l'interface Chaos Mesh

```bash
# Créer le compte de service
kubectl create serviceaccount chaos-admin -n chaos-mesh

# Lui donner les droits d'administrateur
kubectl create clusterrolebinding chaos-admin-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=chaos-mesh:chaos-admin

# Générer le Token (à copier-coller dans l'interface web)
kubectl create token chaos-admin -n chaos-mesh
```

---

### 🧪 4. Lancer une Expérience de Chaos

```bash
# Lancer l'attaque "Pod Kill" configurée
kubectl apply -f k8s/chaos-test.yaml

# Surveiller le crash et la recréation des pods en direct
kubectl get pods -w

# Arrêter l'attaque
kubectl delete -f k8s/chaos-test.yaml
```

---

### 🧹 5. Teardown — Nettoyage Complet

```bash
# Détruire le cluster et libérer les ressources
make down

# Ou manuellement :
kind delete cluster --name k8s-lab
```

---

## 📂 Structure du Projet

```
k8s-lab/
├── k8s/
│   ├── deployment.yaml     # Déploiement Nginx avec replicas et probes
│   ├── service.yaml        # Exposition du service
│   └── chaos-test.yaml     # Expérience Chaos Mesh (Pod Kill cyclique)
├── Makefile                # Commandes automatisées (up, down, monitoring, chaos)
└── README.md
```

---

## 📜 Licence

Ce projet est à des fins éducatives et de démonstration. Libre d'utilisation et de modification.
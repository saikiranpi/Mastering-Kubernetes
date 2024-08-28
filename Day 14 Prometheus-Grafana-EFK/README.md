

![Elastic Search](https://github.com/user-attachments/assets/8241bae3-66fb-4462-8a68-cdec3b38c74a)


# Monitoring and Logging Setup with Prometheus, Grafana, and EFK on Kubernetes

This guide walks through the steps to set up Prometheus, Grafana, and the EFK stack (Elasticsearch, Fluentd, and Kibana) in a Kubernetes environment. These tools are essential for monitoring cluster health, resource usage, and centralized log management.

## Overview

- **Prometheus:** An open-source systems monitoring and alerting toolkit. Prometheus scrapes metrics from configured endpoints and stores them in a time series database. It is widely used for monitoring Kubernetes clusters.

- **Grafana:** A multi-platform open-source analytics and interactive visualization web application. Grafana provides charts, graphs, and alerts for the web when connected to supported data sources such as Prometheus.

- **EFK Stack:** 
  - **Elasticsearch:** A search and analytics engine that stores and indexes log data.
  - **Fluentd:** An open-source data collector that unifies log data collection and consumption.
  - **Kibana:** An open-source data visualization dashboard for Elasticsearch, used to explore and visualize logs.

## Prerequisites

- A Kubernetes cluster
- kubectl installed and configured
- Helm installed on your local machine

## Step 1: Install Helm

Helm is a package manager for Kubernetes, which helps to install, update, and manage Kubernetes applications.

```bash
cd /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 777 get-helm.sh
./get-helm.sh
```

## Step 2: Create a Namespace for Prometheus

Namespaces in Kubernetes allow you to partition your cluster's resources between multiple users.

```bash
kubectl create namespace prom
```

## Step 3: Install Prometheus and Grafana

Add the Prometheus Helm repository and install the Prometheus-Grafana stack.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n prom
```

### Step 4: Verify Installation

Check the services to ensure Prometheus and Grafana are running.

```bash
kubectl get services -n prom
```

### Step 5: Port Forwarding for Prometheus and Grafana

Access Prometheus and Grafana through port forwarding:

- **Prometheus:**

```bash
kubectl port-forward pod/prometheus-prometheus-kube-prometheus-prometheus-0 9090:9090 -n prom
```

- **Grafana:**

```bash
kubectl port-forward pod/prometheus-grafana-57b76f9754-44cx7 3000:3000 -n prom
```

Access Grafana by navigating to `http://localhost:3000` in your web browser. The default username and password are `admin/prom-operator`.

## Step 6: Configure Grafana

### Add Data Source

- In Grafana, navigate to `Configuration > Data Sources > Add Data Source`.
- Choose Prometheus as the data source.
- Set the URL to your Prometheus endpoint: `http://prometheus-kube-prometheus-prometheus.prom.svc.cluster.local:9090`.
- Save & Test the data source.

### Step 7: Create Dashboards

Create custom dashboards in Grafana:

- **Node Metrics Dashboard:** Monitor node health, resource utilization, etc.
- **Pod Metrics Dashboard:** Monitor pod-specific metrics.
- **Cluster Metrics Dashboard:** Overview of the entire cluster.

You can also import pre-built dashboards. For example, import dashboard ID `10000` to get started quickly.

## Step 8: Deploy a Test Application

Deploy an application with multiple replicas to generate metrics.

```bash
kubectl create deployment test-app --image=nginx --replicas=6
```

Monitor the application in the Grafana dashboards you created.

## Step 9: Set Up Centralized Logging with EFK

To collect and manage logs centrally, we'll deploy the EFK stack.

### Step 9.1: Create a Namespace for Logging

```bash
kubectl create namespace kube-logging
```

### Step 9.2: Deploy Elasticsearch

Deploy Elasticsearch in the `kube-logging` namespace.

### Step 9.3: Deploy Kibana

Deploy Kibana in the `kube-logging` namespace.

### Step 9.4: Deploy Fluentd

Deploy Fluentd, which will collect and forward logs to Elasticsearch.

## Step 10: Access Kibana

Port forward the Kibana service and access it via a web browser.

```bash
kubectl port-forward service/kibana 5601:5601 -n kube-logging
```

Navigate to `http://localhost:5601` to access Kibana.

---

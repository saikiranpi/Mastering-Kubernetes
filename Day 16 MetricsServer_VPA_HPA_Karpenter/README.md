![a-3d-render-of-a-youtube-thumbnail-with-a-gradient-PStxY4DSSoy9tgpoStCoYg-AM_brcX1QVC6Mk6Pb45qfA](https://github.com/user-attachments/assets/6cb9e1de-0eaf-43ee-9d67-1c7767f69d14)


# Kubernetes Metrics Server & Horizontal Pod Autoscaling

This repository provides a detailed guide on setting up Kubernetes Metrics Server and implementing Horizontal Pod Autoscaling (HPA). The steps and explanations are based on the article: [Kubernetes Metrics Server & Horizontal Pod Autoscaling](https://medium.com/@pinapathrunisaikiran/kubernetes-metricsserver-horizontal-pod-autoscaling-179e244d365f).

## 📄 Overview

Kubernetes offers Horizontal Pod Autoscaling (HPA) to automatically adjust the number of pods in a deployment, replicaset, or replication controller based on observed CPU/memory metrics or other custom metrics. To enable this feature, we need the Metrics Server, which collects resource metrics from the Kubernetes nodes and pods.

This guide covers:

- Installing the **Kubernetes Metrics Server**
- Setting up **Horizontal Pod Autoscaling** for a deployment
- Testing the autoscaling mechanism

## 🚀 Prerequisites

Before proceeding, ensure you have the following:

- A running **Kubernetes cluster** (e.g., Minikube, EKS, GKE, etc.)
- `kubectl` installed and configured to interact with your cluster
- Metrics Server YAML or Helm chart for installation

## 🛠️ Installation & Setup

### Step 1: Install Kubernetes Metrics Server

The Metrics Server is a cluster-wide aggregator of resource usage data. Install it using the official YAML or a Helm chart.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

After installation, ensure that the Metrics Server is running:

```bash
kubectl get apiservices | grep metrics
```

### Step 2: Verify Metrics

Check if the nodes and pods' metrics are available:

```bash
kubectl top nodes
kubectl top pods
```

### Step 3: Set Up Horizontal Pod Autoscaling (HPA)

Once the Metrics Server is running, you can configure the HPA for a deployment. Here's an example of creating an HPA based on CPU usage:

```bash
kubectl autoscale deployment <your-deployment> --cpu-percent=50 --min=1 --max=10
```

This command automatically scales your deployment between 1 and 10 pods when CPU usage exceeds 50%.

### Step 4: Testing Autoscaling

To test the autoscaling, you can generate load using a stress tool or by running high-CPU workloads.

```bash
kubectl run -i --tty load-generator --image=busybox /bin/sh
# Inside the pod
while true; do wget -q -O- http://<your-app-service>; done
```

Observe the HPA in action:

```bash
kubectl get hpa
```

## 🔗 Reference

For a more detailed guide, please refer to the original article on Medium:  
[Kubernetes Metrics Server & Horizontal Pod Autoscaling](https://medium.com/@pinapathrunisaikiran/kubernetes-metricsserver-horizontal-pod-autoscaling-179e244d365f)

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue if you have suggestions or encounter any problems.

---

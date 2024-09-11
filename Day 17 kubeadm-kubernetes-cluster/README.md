![a-3d-render-of-a-dark-blue-background-with-a-white-gNSW1JL2RbiX9cSkUMsoNw-ekPyecE9RdmbDWhNNABo2w](https://github.com/user-attachments/assets/6d05c7ae-a0a8-45a4-ad97-2768ee4e5269)

# Installing Kubernetes Cluster with kubeadm

This guide provides step-by-step instructions to set up a Kubernetes cluster on three `t2.medium` AWS EC2 instances with 15GB root volumes. We'll be disabling swap, installing the container runtime, and setting up a control plane with two worker nodes using `kubeadm`.

## Requirements

- AWS account
- 3 x t2.medium EC2 instances with 15GB root volume
- SSH access to all instances

---

## Step 1: Launch EC2 Instances

Launch 3 x `t2.medium` EC2 instances with 15GB root volumes. In the "Advanced Details" section of the launch configuration, add the following to the User Data to disable swap:

```bash
#!/bin/bash
sudo apt update && apt install -y net-tools unzip
sudo swapoff -a
sudo apt install sed -y
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

---

## Step 2: Install Container Runtime on Each Server

SSH into each server using their public IP and install `containerd`:

```bash
sudo apt update && apt install containerd -y
ps -ef | grep -i containerd | grep -v grep
netstat -nltp | grep -i containerd | grep -v grep
```

---

## Step 3: Install Kubernetes Tools

Follow the [Kubernetes official documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) to install the necessary tools for Kubernetes.

Install `kubelet`, `kubeadm`, and `kubectl` on all nodes:

```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

## Step 4: Initialize the Control Plane (Master Node)

On the master node, enable necessary kernel modules and initialize the Kubernetes control plane:

```bash
sudo modprobe br_netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward

sudo kubeadm init --cri-socket /run/containerd/containerd.sock \
--pod-network-cidr=192.168.0.0/16
```

Set up `kubectl` for the master node:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify that the Kubernetes control plane is running:

```bash
kubectl get pods -n kube-system
```

---

## Step 5: Install Calico CNI for Pod Networking

Install the Calico CNI plugin to enable pod networking:

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml
```

---

## Step 6: Adding Worker Nodes to the Cluster

### Disable Swap on Worker Nodes

Log in to each worker node and disable swap:

```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo apt update && apt install -y net-tools unzip
```

### Install Container Runtime

On each worker node, install the container runtime:

```bash
sudo apt update && apt install containerd -y
```

### Install Kubernetes Tools

On each worker node, install `kubelet`, `kubeadm`, and `kubectl`:

```bash
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo modprobe br_netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward
```

---

## Step 7: Join Worker Nodes to the Cluster

### Generate Join Token on the Master Node

On the master node, generate the token and join command:

```bash
kubeadm token generate
kubeadm token create jl1zrq.x425cqqcp87phctf --print-join-command
```

### Run the Join Command on Worker Nodes

Run the generated `kubeadm join` command on each worker node.

---

## Step 8: Verify Cluster Status

On the master node, verify that the worker nodes have joined the cluster:

```bash
kubectl get nodes
```

---

## Troubleshooting

If the node is not ready, use the following command to remove the `not-ready` taint:

```bash
kubectl taint nodes <node-name> node.kubernetes.io/not-ready-
```

---

## Conclusion

You've successfully set up a 3-node Kubernetes cluster with `kubeadm` on AWS EC2. The cluster includes one master node and two worker nodes. Pods can now communicate across the cluster using the Calico CNI.

```

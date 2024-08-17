
![a-complex-architectural-diagram-of-kubernetes-adva-J_o5-RfFRxmWQDgp8Ahcyg-RNp8S5GUS-iPezz7oWVS6g](https://github.com/user-attachments/assets/457d85ae-4b18-430a-81a4-52ec0d3f1c3a)


# Advanced Kubernetes Scheduling

This repository demonstrates advanced scheduling techniques in Kubernetes, including Node Selector, Node Affinity, Taints & Tolerations, and Pod Affinity & Anti-Affinity. These techniques allow you to fine-tune how your workloads are distributed across your cluster, ensuring optimal performance and resource utilization.

## Topics Covered

### 1. Node Selector

**Node Selector** is a simple way to ensure that your pods run on specific nodes by assigning labels. This is useful when you have nodes with special hardware or software configurations and you want certain workloads to run only on those nodes.

- **Example Use Case:** Targeting a node with high-performance CPUs for compute-intensive tasks.

```sh
# Label a node with a custom label
kubectl label node <node-name> high-perf-cpu=yes

# Deploy a pod targeting the node with the specified label
kubectl apply -f <your-deployment-file>.yaml

# Verify that the pod is running on the correct node
kubectl get pods -o wide --no-headers | awk -F" " '{print $1, $8}'
```

### 2. Node Affinity

**Node Affinity** allows more complex scheduling decisions based on node labels. Unlike Node Selector, Node Affinity supports multiple label expressions and can differentiate between preferred and required conditions.

- **Example Use Case:** Ensuring that pods are deployed only on nodes with specific environmental settings or hardware.

```sh
# Label nodes with different environment labels
kubectl label node <node1-id> env=one
kubectl label node <node2-id> env=two
kubectl label node <node3-id> env=three

# Deploy a workload with Node Affinity rules
kubectl apply -f <your-deployment-file>.yaml

# Scale the deployment to observe how pods are distributed
kubectl scale deployment <deployment-name> --replicas=8
```

### 3. Taints & Tolerations

**Taints** are applied to nodes to prevent pods that don't tolerate the taint from being scheduled on them. **Tolerations** are applied to pods to allow them to be scheduled on tainted nodes. This feature is essential for keeping certain workloads separate or ensuring critical workloads are not disrupted.

- **Example Use Case:** Ensuring that only specific pods can run on a node reserved for special tasks.

```sh
# Taint nodes to control scheduling
kubectl taint node <node-id> high-cpu=yes:NoSchedule
kubectl taint node <node-id> med-cpu=yes:NoExecute

# Describe the node to see its taints
kubectl describe node <node-id> | grep -i high

# Deploy a pod to see if it gets scheduled based on tolerations
kubectl apply -f <your-deployment-file>.yaml

# Remove taints from nodes if needed
kubectl taint node <node-id> high-cpu-
kubectl taint node <node-id> med-cpu-
```

### 4. Pod Affinity & Anti-Affinity

**Pod Affinity** allows you to schedule pods together on the same node, while **Pod Anti-Affinity** ensures that pods are placed on separate nodes. This is useful for reducing latency between pods or ensuring high availability by spreading pods across nodes.

- **Example Use Case:** Grouping frontend and backend pods together to reduce network latency or ensuring that replicas of the same service are spread out to avoid single points of failure.

```sh
# Use pod affinity or anti-affinity in your deployment YAML
kubectl apply -f <your-deployment-file>.yaml

# Scale the deployment and observe the behavior
kubectl scale deployment <deployment-name> --replicas=2

# Drain a node to see how pods are rescheduled
kubectl drain <node-id>
kubectl uncordon <node-id>
```

## Commands Overview

Here’s a summary of the key commands used for the topics covered:

```sh
# Label a node
kubectl label node <node-name> high-perf-cpu=yes

# Apply a deployment file
kubectl apply -f <your-deployment-file>.yaml

# Verify pod placement
kubectl get pods -o wide --no-headers | awk -F" " '{print $1, $8}'

# Label nodes for Node Affinity
kubectl label node <node1-id> env=one
kubectl label node <node2-id> env=two
kubectl label node <node3-id> env=three

# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=8

# Taint nodes
kubectl taint node <node-id> high-cpu=yes:NoSchedule
kubectl taint node <node-id> med-cpu=yes:NoExecute

# Remove taints from nodes
kubectl taint node <node-id> high-cpu-
kubectl taint node <node-id> med-cpu-

# Drain and uncordon a node
kubectl drain <node-id>
kubectl uncordon <node-id>
```

## Conclusion

This repository provides practical examples and commands to help you understand and implement advanced scheduling techniques in Kubernetes. By mastering these concepts, you can ensure that your applications run efficiently and reliably in a Kubernetes environment.

---

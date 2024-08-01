![sure-how-about-this-for-your-youtube-thumbnail-pro-wLRSQwKfRoyjFN-MshmBmA-q_0yO9OtTrKTmBtA1HE1rg](https://github.com/user-attachments/assets/fcbecebd-2d12-423d-879b-fa0c4cce8eb7)


---

# Kubernetes Sidecar Containers and Resource Quotas

## Overview

This repository provides a practical demonstration of Kubernetes Sidecar containers and Resource Quotas, as covered in our YouTube video. It includes example configurations and scripts to help you understand and implement these concepts effectively.

## Contents

### Sidecar Containers

1. **Sidecar Containers Overview**: Explanation of Sidecar containers, their use cases, and how they complement the main containers.
   - **Init Containers**: Containers that run before the main container to check dependencies.
   - **Adapter Containers**: Containers that run alongside the main container for purposes such as logging, metrics collection, and proxy services.
   - **Ambassador Containers**: Containers that act as proxies for external resources.

2. **Example**:
   - **Deployment Configuration**: YAML files for deploying a service with Init Containers and Adapter Containers.
   - **Service Mesh Example**: Demonstration using Istio Envoy Proxy.

### Resource Quotas

1. **Resource Quotas Overview**: Explanation of how Resource Quotas manage resource usage within namespaces.
   - **Resource Units**: Mi (Mebibyte), m (millicores), Gi (Gibibyte)
   - **Example Setup**: Configurations for applying Resource Quotas to namespaces like Development and Staging.

2. **Example**:
   - **Namespace Creation**: YAML files to create namespaces with Resource Quotas.
   - **Pod Creation**: Steps to deploy pods and observe resource restrictions.

## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/sidecar-containers-resource-quota.git
   ```

2. **Apply Kubernetes Configurations**:
   ```bash
   kubectl apply -f deployments/
   kubectl apply -f resource-quota/
   ```

3. **Check Logs and Resource Usage**:
   - View Init container logs:
     ```bash
     kubectl logs <init-container-pod> -c <init-container-name> -f
     ```
   - Monitor resource usage and quotas:
     ```bash
     kubectl describe namespace <namespace-name>
     ```

## Resources

- [Kubernetes Documentation on Sidecar Containers](https://kubernetes.io/docs/concepts/workloads/pods/#sidecar-containers)
- [Kubernetes Documentation on Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

---

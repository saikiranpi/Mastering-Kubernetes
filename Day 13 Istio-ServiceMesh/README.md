![a-modern-tech-focused-illustration-of-a-dynamic-sc-yEoiLRGiTwWTOzk6BxOBkA-FMgaa7fVRFitnWsNkTrETw](https://github.com/user-attachments/assets/154a776f-832a-4ebc-bef0-32839da96be6)


#Istio Service Mesh

This guide will walk you through setting up a Service Mesh using Istio. The app consists of five microservices:

1. **User Service** - Handles user information
2. **Restaurant Service** - Manages restaurant data
3. **Order Service** - Processes orders
4. **Delivery Service** - Coordinates delivery
5. **Payment Service** - Manages payments

## Why Use a Service Mesh?

Before Service Mesh, each microservice communicated directly with others using REST APIs or gRPC over HTTP. However, this approach required each service to handle its own security, retries, and monitoring, which made the system complex and hard to manage. Developers had to write a lot of custom code to handle these tasks.

**Enter Istio**: A service mesh that automatically manages communication between services. Istio handles:

- **Security**: Ensures services communicate securely.
- **Retries**: Automatically retries failed requests.
- **Traffic Control**: Monitors and manages traffic between services.

With Istio, developers can focus on building features rather than managing communication.

## Installation Guide

### 1. Install Istio

Install Istio by running the following commands:

```bash
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.0 sh -
cp istio-1.18.0/bin/istioctl /usr/local/bin/
istioctl --version
```

### 2. Deploy Istio Ingress Gateway

Create and deploy the Istio Ingress Gateway:

```bash
nano /tmp/istio-ingressgateway.yml
istioctl install --set profile=minimal -f istio-ingressgateway.yml
```

### 3. Install Prometheus for Monitoring

Deploy Prometheus in the Istio namespace:

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.16/samples/addons/prometheus.yaml
```

### 4. Enable Istio on the Default Namespace

Enable Istio for the default namespace where your microservices are deployed:

```bash
kubectl label namespace default istio-injection=enabled
```

### 5. Install Kiali and Jaeger for Visualization and Tracing

Deploy Kiali (for dashboard) and Jaeger (for tracing) in the Istio namespace:

```bash
# Kiali
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.16/samples/addons/kiali.yaml

# Jaeger
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.16/samples/addons/jaeger.yaml
```

### 6. Deploy the Voting Application

Deploy your voting application in the default namespace, ensuring that you create the necessary secrets for private Docker images.

1. Create TLS keys:

    ```bash
    nano tls.key
    nano tls.crt
    ```

2. Create secrets in both namespaces:

    ```bash
    kubectl create secret tls my-tls-secret --key="tls.key" --cert="tls.crt" -n istio-system
    kubectl create secret tls my-tls-secret --key="tls.key" --cert="tls.crt" -n default
    ```

### 7. Update Route 53 Records and Deploy Gateway

Before deploying, update your DNS records in Route 53. Then deploy the gateway:

```bash
nano votingapp-gw-vs-ssl.yaml
# Deploy the gateway
kubectl apply -f votingapp-gw-vs-ssl.yaml -n default
```

### 8. Monitor Your Services

Use Kiali and Jaeger in the Istio namespace to monitor and trace your services.

---

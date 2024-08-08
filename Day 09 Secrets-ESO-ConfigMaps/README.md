<img width="960" alt="KUBERNETES" src="https://github.com/user-attachments/assets/42be8f01-1bb8-44e4-ad1e-73aa3e1846e2">



---

# Kubernetes Configuration Guide: ConfigMaps & Secrets

## Overview

This guide provides an overview of how to use ConfigMaps and Secrets in Kubernetes to manage non-sensitive and sensitive information respectively. It includes examples and commands to create, manage, and use ConfigMaps and Secrets in your Kubernetes deployments.

### ConfigMaps

ConfigMaps are used to store non-sensitive configuration data in key-value pairs. 

**Example:**

Keys: `database_host`, `database_port`, `log_level`

Values: `"db.example.com"`, `"5432"`, `"info"`

### Secrets

Secrets are used to store sensitive data such as TLS certificates, passwords, and keys. They are used in a similar manner to ConfigMaps but are managed with more security.

## Usage Scenarios

### 1. Registry

#### Pulling a Docker Image from a Private Repo

1. **Create a Private Repo in Docker**
2. **Pull a Public Image, Tag it, and Push to the Private Repo**
3. **Run Docker Secret Command**
4. **Create Deployment and Add Secrets**

```yaml
containers: 
- image: kiran2361993/votingapp:worker
  name: worker
imagePullSecrets:
- name: docker-pwd
```

### 2. Generic Secrets

#### Managing AWS Credentials

1. **Delete Deployment and Run a New One with Troubleshooting Tools**

```bash
kubectl exec -it <pod_name> -- aws s3 ls
```

2. **Create IAM Access Key and Secret Key**

3. **Create Generic Secrets**

```bash
kubectl create secret generic db-user --from-literal=username=XXXXXX
kubectl create secret generic db-pass --from-literal=password='XXXXXXXXXXXX'
kubectl get secrets
kubectl get secret db-user -o jsonpath="{.data.username}" | base64 --decode
kubectl get secret db-pass -o jsonpath="{.data.password}" | base64 --decode
```

4. **Base64 Encode Credentials**

```bash
echo -n AccessKey | base64
echo -n SecretKey | base64
```

5. **Create `Secret.yaml` and Deploy**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-credentials
data:
  accesskey: <base64_encoded_access_key>
  secretkey: <base64_encoded_secret_key>
```

6. **Deploy the Deployment Using Secrets**

7. **Login to Container and Run AWS Commands**

```bash
kubectl exec -it <pod_name> -- aws s3 ls
```

### File Mount

1. **Checkout VSCode**
2. **Login to Container and Check Environment Variables**

```bash
kubectl exec -it <pod_name> -- env
```

3. **Access Stored AWS Keys**

```bash
cat /root/.aws
aws ec2 describe-vpcs --region us-east-2
```

## ConfigMaps

1. **Copy Nginx Config File to Root and Edit**

```bash
nano default.config
```

2. **Create ConfigMap**

```bash
kubectl create configmap default.conf --from-file=default.conf
kubectl describe cm default.conf
```

3. **Deploy and Expose the Deployment**

```bash
kubectl apply -f deployment.yaml
kubectl expose deployment <deployment_name> --type=LoadBalancer --name=<service_name>
```

---

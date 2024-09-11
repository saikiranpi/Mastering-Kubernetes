![a-3d-render-of-a-server-room-with-multiple-servers-KJnymKrnRpGVmM6sp62QtQ-9Fu6SanWTserUzmCqMAc4Q](https://github.com/user-attachments/assets/2878f9db-180d-4762-8976-d2f796865f56)


# **EKS Cluster Deployment and Jenkins Integration**

## **Overview**

This repository contains scripts and instructions for automating the deployment of an EKS Cluster and its integration with Jenkins for continuous deployment. The setup includes creating an EKS control plane, configuring OIDC, deploying node groups, and setting up a Jenkins pipeline for automated deployments.

---

## **Prerequisites**

Before you begin, ensure you have the following:

- An AWS account with the necessary IAM permissions:
  - `AmazonEKSClusterPolicy`
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKSServicePolicy`
- An EC2 instance with:
  - `t2.large` type
  - `20GB` storage
- SSH Key pair for EC2 access.
- Jenkins server installed on the EC2 instance.

---

## **Installation**

### **1. EC2 Instance Setup**

- Launch a `t2.large` EC2 instance with `20GB` storage.
- SSH into your instance and install the required dependencies:
  ```bash
  sudo apt update
  sudo apt install -y unzip awscli openjdk-11-jdk
  ```

### **2. Install kubectl**

```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv ./kubectl /usr/local/bin/kubectl
chmod 777 /usr/local/bin/kubectl
kubectl version --short
```

### **3. Install eksctl**

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
sudo chmod 700 /usr/local/bin/eksctl
eksctl version
```

---

## **Cluster Deployment**

### **1. Create EKS Control Plane**

Run the following command to create the EKS cluster control plane:

```bash
eksctl create cluster \
--name eks-cluster-1 \
--version 1.29 \
--zones=us-east-1a,us-east-1b,us-east-1c \
--without-nodegroup
```

### **2. Associate OIDC Provider**

```bash
eksctl utils associate-iam-oidc-provider \
--region us-east-1 \
--cluster eks-cluster-1 \
--approve
```

### **3. Create Node Group**

```bash
eksctl create nodegroup --cluster=eks-cluster-1 \
--region=us-east-1 \
--name=eks-cluster-1-ng-1 \
--node-type=t3.medium \
--nodes=2 \
--nodes-min=2 \
--nodes-max=4 \
--node-volume-size=20 \
--ssh-access \
--ssh-public-key=YourKeyPair \
--managed \
--asg-access \
--external-dns-access \
--full-ecr-access \
--appmesh-access \
--alb-ingress-access
```

---

## **Jenkins Integration**

### **1. Install Jenkins Plugins**
Ensure you have installed the following plugins:
- AWS CLI Plugin
- Kustomization Plugin

### **2. Configure Jenkins Credentials**

- Add your AWS credentials to Jenkins under `Manage Jenkins` > `Credentials`.
- Set up an SSH key pair for Jenkins to access the GitHub repository.

### **3. Create Multibranch Pipeline**

- Set up a Multibranch Pipeline in Jenkins.
- Configure a GitHub webhook to trigger builds automatically.

---

## **Testing**

- Run `kubectl get pods -A` to ensure your cluster is up and running.
- Test the Jenkins pipeline by pushing code to your GitHub repository. The pipeline should automatically trigger and deploy to the appropriate namespace (development or production).

---

## **Cleanup**

To delete the EKS cluster:

```bash
eksctl delete cluster --name eks-cluster-1
```

---

## **Contributing**

Feel free to open issues and submit pull requests for any improvements or fixes.

---

## **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

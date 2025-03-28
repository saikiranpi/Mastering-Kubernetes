# Create EKS Cluster

## Prerequisites

### 1. Install AWS CLI
```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

### 2. Install kubectl
```sh
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

### 3. Install eksctl
```sh
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

---

## PVCs Dynamic Provisioning

### 1. Associate IAM OIDC Provider with the Cluster
```sh
eksctl utils associate-iam-oidc-provider --cluster <Cluster-name> --approve --region us-east-2
```
- Check the Identity Providers section in IAM; a new OIDC provider will be created.

### 2. Create IAM Role for EBS CSI Driver
```sh
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster <Cluster-name> \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_Driver_Role \
  --region us-east-2
```
- This command creates a role in AWS IAM.
- The `AmazonEBSCSIDriverPolicy` policy already exists in your AWS account.
- The role `AmazonEKS_EBS_CSI_Driver_Role` is created with the above policy.

### 3. Install the AWS EBS CSI Driver Add-on
```sh
eksctl create addon --name aws-ebs-csi-driver --cluster <Your-cluster-name> --service-account-role-arn arn:aws:iam::<Your-account-ID>:role/AmazonEKS_EBS_CSI_Driver_Role --region us-east-2 --force
```
- The `aws-ebs-csi-driver` add-on is responsible for dynamically provisioning EBS volumes for EKS.

### 4. Create a Storage Class
Create a file `storageclass.yaml`:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
  encrypted: "true"
```
Apply the storage class:
```sh
kubectl apply -f storageclass.yaml
```
Verify creation:
```sh
kubectl get sc
```
- The `ebs-sc` storage class should now be created.

### 5. Create PVC and Deployment YAML Files
#### `pvc.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 4Gi
```

#### `deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ebs
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-ebs
  template:
    metadata:
      labels:
        app: nginx-ebs
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: ebs-volume
          mountPath: /usr/share/nginx/html
      volumes:
      - name: ebs-volume
        persistentVolumeClaim:
          claimName: ebs-claim
```
Apply the manifests:
```sh
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
```
- Verify that the PV, PVC, and Pod are running.
- Check the **Volumes** section in the EC2 Dashboard; a new EBS volume should be created.

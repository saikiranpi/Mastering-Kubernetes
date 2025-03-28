# create EKS Cluster

#Prerequits
1.  **Install AWS CLI**
```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws configure
 ```
2.  **Install Kubectl**
      ```sh
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
      ```

3.   **Install eksctl**
     ```sh
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
      ```

#For PVCs Dynamic Provisioning

1.   Associating IAM OIDC Provider with my cluster

    '''sh
    eksctl utils associate-iam-oidc-provider --cluster <Cluster-name>  --approve --region us-east-2
    '''
    - •	Check the Identity providers  in IAM an new OIDC will be created

2.  Creating IAM role with the necessary permissions for the EBS CSI Driver and sets up a trust relationship between this IAM role and the Kubernetes service account.

    '''sh
    eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster <Cluster-name> \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_Driver_Role \
  --region us-east-2
    '''

    •	The above command is responsible for creating a role in your AWS IAM
•	Here policy named AmazonEBSCSIDriverPolicy is already present in AWS account
•	You are creating a role named AmazonEKS_EBS_CSI_Driver_Role  with above policy.

3.  Install the AWS EBS CSI Driver Addon
    '''sh
    eksctl create addon --name aws-ebs-csi-driver --cluster <Your-cluster-name> --service-account-role-arn arn:aws:iam::<Your-account-ID>:role/AmazonEKS_EBS_CSI_Driver_Role --region us-east-2 --force
    '''

    •	Here in the above command we are installing a add-on named aws-ebs-csi-driver which is responsible for creating a volume for us from EKS
•	In detail explanation will be given in this dox at ending.

4.  Create a storage class using this manifest given below

'''sh
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
  encrypted: "true"
'''
•	Kubectl apply -f storageclass.yaml
•	Check weather  its created or not kubectl get sc
•	Now you can see ebs-sc named storage class will be created.
•	In detail about storage class will be given at ending

5.  Create PVC and a Deployment yaml file 

'''sh
# PVC.yaml
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
'''

'''sh
# Deployment.yaml
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
'''
•	Now you can see pv, pvc and pod will be running.
•	Check in Volumes section EC2 Dashboard new volume will be created.



![4](https://github.com/user-attachments/assets/42e73161-b34f-4953-b600-d169c7c98517)


# Kubernetes Deployments 
This repository provides a simple guide and example commands to help you understand and work with Kubernetes Deployments, DaemonSets, and StatefulSets.

Overview
Deployments
Deployments are used by 99.99% of people to deploy their applications. They include ReplicaSets and Pods.

DaemonSets
DaemonSets ensure that a pod is run on each node in the cluster. This is typically used for log collection and monitoring.

StatefulSets
StatefulSets maintain the identity of pods, ensuring the hostname remains the same, which is crucial for stateful applications like MongoDB and MySQL.

Commands Used
Creating a Deployment
sh
Copy code
kubectl create deployment testapp --image kiran2361993/kubegame:v1 --replicas 3 --dry-run -o yaml
Adding Another Container
Add the following container to the deployment:

Image: kiran2361993/mydb:v1
Name: Database
Labels and Annotations
Labels are key-value pairs used to pass information.

Creating Pods
sh
Copy code
kubectl run testpod1 --image nginx:latest
Deploying the Deployment
sh
Copy code
kubectl apply -f deployment.yaml
kubectl get pods
Adding Annotations
Annotations can pass information such as:

Info: "This Deployment file has been created by Saikiran Pinapathruni"
Email: "pinapathruni.saikiran@gmail.com"
Owner: "Saikiran Pinapathruni"
Environment Variables
Set environment variables at the container level:

yaml
Copy code
env:
  - name: DB_NAME
    value: "mysqldb"
  - name: DB_PORT
    value: "3306"
  - name: DB_URL
    value: "saikiranpi.in/mydb"
Checking Environment Variables
sh
Copy code
kubectl describe pod <podname>
kubectl exec -it <podname> -- bash
env
Exposing the Deployment
sh
Copy code
kubectl expose deployment testapp --name sv1 --port 8000 --target-port 80 --type NodePort
kubectl expose deployment testapp --name sv2 --port 5000 --target-port 5000 --type NodePort
Strategy
sh
Copy code
kubectl explain deployment.spec.strategy
Under spec:

yaml
Copy code
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0%
Deployment Update Strategy
sh
Copy code
kubectl edit deployment testapp
Under spec:

yaml
Copy code
minReadySeconds: 10
maxUnavailable: 0
DaemonSets and StatefulSets
DaemonSets
DaemonSets ensure that one pod is run on each node.

StatefulSets
StatefulSets maintain the identity of pods, ensuring the hostname remains the same.

Interview Questions
What is the difference between Deployments, DaemonSets, and StatefulSets?

Deployments: Used for stateless applications, allowing for scaling up and down without dependencies on pod names.
DaemonSets: Ensure one pod per node, typically used for log collection and monitoring.
StatefulSets: Maintain pod identity, crucial for stateful applications like databases.

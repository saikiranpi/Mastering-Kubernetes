
![a-captivating-thumbnail-concept-for-a-kubernetes-r-dI9hfXL_TDK-RFxhKkQM7g-Pe7hg8EwSqW2lXlnt-3DNw](https://github.com/user-attachments/assets/5e278522-6e08-4538-80ec-b6a138fde2a5)

# Kubernetes RBAC Setup Guide

This guide provides instructions for setting up Role-Based Access Control (RBAC) for users and namespaces in a Kubernetes cluster.

## Why Use RBAC?

RBAC (Role-Based Access Control) is crucial for managing permissions and ensuring security within a Kubernetes cluster. It allows you to:

- **Control Access**: Define who can access specific resources and what actions they can perform. This is essential for enforcing security policies and preventing unauthorized access.
- **Segregate Duties**: Assign different roles to users based on their responsibilities. For instance, some users might only need read access, while others require full administrative privileges.
- **Enhance Security**: Minimize the risk of accidental or malicious actions by limiting user permissions to only what is necessary for their role.
- **Simplify Management**: Manage permissions at a granular level, making it easier to oversee and adjust access as needed.

## Steps to Follow

### 1. Copy Keys for Cluster Creation

Ensure you have the necessary keys and certificates:

- Copy the keys and certificates to the appropriate directories (`.ssh/` and `private key`).

### 2. Create Namespaces

Create two namespaces: `development` and `production`.

### 3. Copy CA Certificates

Copy the following files from the master to the management server:
- `ca.crt`
- `ca.key`

### 4. Create Users

#### User 1: `saikiran`

Generate the key and certificate:

```bash
openssl genrsa -out saikiran.key 2048
openssl req -new -key saikiran.key -out saikiran.csr -subj "/CN=saikiran/O=clusteradmin"
openssl x509 -req -in saikiran.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out saikiran.crt -days 365
```

#### User 2: `user2`

Generate the key and certificate:

```bash
openssl genrsa -out user2.key 2048
openssl req -new -key user2.key -out user2.csr -subj "/CN=user2/O=production"
openssl x509 -req -in user2.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out user2.crt -days 365
```

### 5. Copy Certificates and Keys

Copy all `.crt` and `.key` files to the master root location safely.

### 6. Create Config Files for Users

For User 1:

```bash
export KUBECONFIG=/root/USER1-CONFIG
```

For User 2:

```bash
export KUBECONFIG=/root/USER2-CONFIG
```

### 7. Set Up RBAC Roles and Bindings

Create roles and role bindings for the users, including:

- **RoleBindings** for namespace-specific permissions
- **ClusterRoleBindings** for cluster-wide permissions

### 8. Admin User Configuration

For the administrator `saikiran`:

```bash
openssl genrsa -out saikiran.key 2048
openssl req -new -key saikiran.key -out saikiran.csr -subj "/CN=saikiran/O=development"
openssl x509 -req -in saikiran.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out saikiran.crt -days 365
```

Copy all `.crt` and `.key` files to the master root location safely.

Create the admin config file:

```bash
export KUBECONFIG=/root/saikiran-CONFIG
```

### 9. Merge Config Files

To combine multiple config files into one:

```bash
export KUBECONFIG=USER1-CONFIG:USER2-CONFIG:SAIKIRAN-CONFIG
kubectl config view --merge --flatten > mixed-config.txt
```

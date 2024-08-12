
![10](https://github.com/user-attachments/assets/46ba9266-5e37-4599-9fd9-b2a4d030ae5a)


# Kubernetes Persistent Storage

This repository provides examples and explanations of different Kubernetes storage options. Here’s a simple guide to understand how different types of persistent storage work in Kubernetes.

## Storage Types

### EmptyDir
- **Purpose**: Used for temporary storage within a pod.
- **Behavior**: Data in an `EmptyDir` is lost if the pod is deleted or restarted. Ideal for temporary files that don’t need to be preserved across pod restarts.

### HostPath
- **Purpose**: Mounts a directory from the host machine into the pod.
- **Example**: You can use `HostPath` to access Docker’s Unix socket at `/var/run/docker.sock` from inside the container. This lets the container communicate with Docker on the host.

### Persistent Volume (PV)
- **Purpose**: Represents a piece of storage in the cluster that has been provisioned by an administrator.
- **Details**: PVs are managed by the cluster and can be dynamically provisioned using storage classes.

### Persistent Volume Claim (PVC)
- **Purpose**: A request for storage by a user. PVCs are used to claim PVs and can be either static or dynamic.

### Storage Class
- **Purpose**: Defines the provisioner and parameters for dynamically provisioning PVs.
- **Dynamic Provisioning**: Automatically creates PVs based on PVC requests using predefined storage classes.

## Tasks

### EmptyDir Example
1. Deploy a pod using `EmptyDir`.
2. Access the container and run:
   ```bash
   for i in {1..10}; do echo $(date) > FILE$I; sleep 1; done
   ```
3. Check the files in `/tmp/myemptydir`.
4. Delete the deployment to remove the pod.

### HostPath Example
1. Create a deployment with 3 replicas using `HostPath`.
2. Access the container and check Docker version:
   ```bash
   docker version
   ```

### Persistent Volume and Claim
1. Create 5 PVs.
2. Use `kubectl get pv` to view them.
3. Claims can be static or dynamic:
   - **Static PVC**: Manually create a PV and PVC.
   - **Dynamic PVC**: Create a PVC and let it automatically provision a PV using storage classes.

4. Test different PVC sizes (2GB, 8GB) and check the claims.
5. Delete PVs and PVCs as needed.

### Dynamic Provisioning
1. Create a PVC with a storage class to automatically provision a PV.
2. View storage classes with:
   ```bash
   kubectl get storageclasses
   ```
3. Deleting all storage classes will affect PVC provisioning.

### Policies
- **AWS Org Policies**: Ensure developers don’t create excessive or unnecessary storage by setting up policies that control resource usage.

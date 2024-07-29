![title-deploying-secure-kubernetes-ingress-with-ssl--yKaGY7MRR6OuKgx91mzOg-t2i_oA8oTZ2jrB9hh6dHFA](https://github.com/user-attachments/assets/145269ff-f908-41ff-ae3f-9d05facc67df)



# Kubernetes Ingress Controllers Setup

This guide will help you set up Ingress Controllers, generate SSL keys, deploy Ingress Controllers, and manage Docker images in a Kubernetes cluster. We'll also create secrets and configure Route 53 records.

## Ingress Controllers

### Steps to Follow:

1. **Generate SSL Keys**
    - Navigate to the `/tmp` directory:
      ```sh
      cd /tmp
      ```
    - Create the key files `tls.key` and `tls.crt`:
      ```sh
      echo "<Your-Private-Key>" > tls.key
      echo "<Your-Certificate>" > tls.crt
      ```

2. **Deploy Ingress Controllers**
    - Create a secret for the SSL keys:
      ```sh
      kubectl create secret tls nginx-tls-default --key="tls.key" --cert="tls.crt"
      ```
    - Verify the secret:
      ```sh
      kubectl describe secret nginx-tls-default
      ```
    - List all secrets:
      ```sh
      kubectl get secrets
      ```

3. **Download Voting Images from Docker and Create a Private Container Registry on AWS**
    - Attach an IAM role to your instance with necessary permissions.
    - Tag and push the images to your private registry. After pushing, remove all local images:
      ```sh
      docker rmi $(docker images -aq) --force
      ```

4. **Deploy the Deployment**
    - Provide all the image details in the YAML manifest and deploy the deployment.
    - Expect an error due to missing secrets.

5. **Create Secrets**
    - Delete the deployment:
      ```sh
      kubectl delete deployment <your-deployment-name>
      ```
    - Create the necessary secrets:
      ```sh
      kubectl create secret docker-registry docker-pwd --docker-username=<your-username> --docker-password=<your-password> --docker-email=<your-email>
      ```

6. **Update YAML Manifest**
    - Add `imagePullSecrets` under the images section in your YAML manifest:
      ```yaml
      imagePullSecrets:
        - name: docker-pwd
      ```

7. **Configure Route 53**
    - Go to Route 53 and create the following records:
      - `www`
      - `vote`
      - `result`

8. **Deploy Ingress**
    - Deploy Ingress for the `result` and `vote` separately.

## Commands Used:

```sh
# Navigate to /tmp directory
cd /tmp

# Create SSL key files
echo "<Your-Private-Key>" > tls.key
echo "<Your-Certificate>" > tls.crt

# Create secret for SSL keys
kubectl create secret tls nginx-tls-default --key="tls.key" --cert="tls.crt"

# Verify the secret
kubectl describe secret nginx-tls-default

# List all secrets
kubectl get secrets

# Tag and push Docker images, then remove local images
docker rmi $(docker images -aq) --force

# Delete the existing deployment
kubectl delete deployment <your-deployment-name>

# Create Docker registry secret
kubectl create secret docker-registry docker-pwd --docker-username=<your-username> --docker-password=<your-password> --docker-email=<your-email>
```


---

This guide provides a simple walkthrough of setting up Ingress Controllers, generating SSL keys, deploying Ingress Controllers, creating secrets, and configuring Route 53 records. Follow the steps and use the commands provided to successfully set up your Kubernetes environment.

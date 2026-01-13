kubectl create secret docker-registry docker-pwd \
--docker-server=docker.io --docker-username=USERNAMEDOCKER \
--docker-password=TOKEN \
--docker-email=YOUREMAILHERE@gmail.com


generic 

kubectl create secret generic db-user --from-literal=username=USERNAME
kubectl create secret generic db-pass --from-literal=password='PWD'

ku get secrets


kubectl get secret db-user -o jsonpath="{.data.username}" | base64 --decode
kubectl get secret db-pass -o jsonpath="{.data.password}" | base64 --decode

echo -n ACCESSKEYHERE | base64
echo -n SECRETEACCESSKEYHERE| base64










































Understood! Let’s use a single Docker image for both examples: one with Secrets and one without Secrets. For demonstration purposes, we'll use the `busybox` image, which is a simple image often used for testing.

### 1. **Example with Secrets**

We'll use the `busybox` image to simulate an application that uses Secrets for sensitive information, such as a database password.

#### Steps:

1. **Create a Secret**

   **Secret YAML (`db-secret.yaml`):**

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: db-secret
   type: Opaque
   data:
     db-password: cGFzc3dvcmQ=  # Base64 encoded 'password'
   ```

   **Explanation:**
   - `db-password` is the key in the Secret that stores the Base64-encoded password.

   **Apply the Secret:**

   ```bash
   kubectl apply -f db-secret.yaml
   ```

2. **Create a Deployment Using the Secret**

   **Deployment YAML (`app-deployment-with-secret.yaml`):**

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-app-with-secret
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: web-app
     template:
       metadata:
         labels:
           app: web-app
       spec:
         containers:
           - name: web-app-container
             image: busybox
             command: ["sh", "-c", "echo DB_PASSWORD=$(cat /etc/secrets/db-password); sleep 3600"]
             volumeMounts:
               - name: secret-volume
                 mountPath: /etc/secrets
                 readOnly: true
         volumes:
           - name: secret-volume
             secret:
               secretName: db-secret
   ```

   **Explanation:**
   - The deployment mounts the Secret at `/etc/secrets`, making the `db-password` available inside the container.
   - The command prints the password from the mounted file to verify that the Secret is being used.

   **Apply the Deployment:**

   ```bash
   kubectl apply -f app-deployment-with-secret.yaml
   ```

3. **Verify the Deployment**

   **Check the Pod logs:**

   ```bash
   kubectl logs -l app=web-app
   ```

   **Explanation:**
   - The logs will show the password read from the Secret.

### 2. **Example Without Secrets**

In this example, we'll configure the same `busybox` image but without using Secrets. Instead, we'll just use a ConfigMap for non-sensitive configuration.

#### Steps:

1. **Create a ConfigMap**

   **ConfigMap YAML (`app-configmap.yaml`):**

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: app-config
   data:
     db-url: "jdbc:mysql://db.example.com:3306/mydb"
   ```

   **Explanation:**
   - `db-url` is a configuration value stored in the ConfigMap.

   **Apply the ConfigMap:**

   ```bash
   kubectl apply -f app-configmap.yaml
   ```

2. **Create a Deployment Using the ConfigMap**

   **Deployment YAML (`app-deployment-with-configmap.yaml`):**

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-app-with-configmap
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: web-app
     template:
       metadata:
         labels:
           app: web-app
       spec:
         containers:
           - name: web-app-container
             image: busybox
             command: ["sh", "-c", "echo DB_URL=$DB_URL; sleep 3600"]
             env:
               - name: DB_URL
                 valueFrom:
                   configMapKeyRef:
                     name: app-config
                     key: db-url
   ```

   **Explanation:**
   - The deployment sets an environment variable `DB_URL` using the value from the ConfigMap.
   - The command prints the configuration value to verify that the ConfigMap is being used.

   **Apply the Deployment:**

   ```bash
   kubectl apply -f app-deployment-with-configmap.yaml
   ```

3. **Verify the Deployment**

   **Check the Pod logs:**

   ```bash
   kubectl logs -l app=web-app
   ```

   **Explanation:**
   - The logs will show the `db-url` read from the ConfigMap.

### Summary:

- **With Secrets:** Use Secrets to handle sensitive information like passwords. Secrets are mounted as files or available as environment variables in the container.
- **Without Secrets:** Use ConfigMaps for non-sensitive configuration data. ConfigMaps are used in a similar way but are not suitable for sensitive information.

These examples should help you understand how to use Secrets and ConfigMaps in Kubernetes, along with their respective use cases. If you need further assistance or have additional questions, just let me know!

![a-creative-illustration-of-a-busy-cloud-based-envi-a0vsZ3G8SUy0oBflnXLJag-C0jszLKpQAm0yYAdGxvG5Q](https://github.com/user-attachments/assets/7ca733d1-e154-4989-8079-db4e90145448)


### Kubernetes Commands Overview Used in the session

**Generate SSH Keys:**
These keys will be used by KOPS and applied to all servers.

```sh
ssh-keygen 
```

---

**Smoke Testing:**

1. **Get Nodes:**
   ```sh
   kubectl get nodes
   ```
   
2. **Get Nodes (No Headers):**
   ```sh
   kubectl get nodes --no-headers
   ```

3. **Cluster Info:**
   ```sh
   kubectl cluster-info
   ```

4. **Get Namespaces:**
   ```sh
   kubectl get ns
   ```
   Example namespaces: Alpha, Bravo, Charlie.

*Note:* If three teams are working on three different projects but using the same cluster, we can isolate with Namespaces. To allow communication between them, use Network Policies.

---

**Pods Information:**

1. **Get Pods (Default Namespace):**
   ```sh
   kubectl get pods
   ```
   Output: "Nothing is there" (if no pods are running)

2. **Get Pods (Kube-System Namespace):**
   ```sh
   kubectl get pods -n kube-system
   ```

3. **Get Pods (Kube-System Namespace, Detailed):**
   ```sh
   kubectl get pods -n kube-system -o wide | grep -i <component-name>
   ```
   Replace `<component-name>` with the specific component you're looking for.

---

**Deploy Resources in Kubernetes:**

1. **Imperative Approach:**
   ```sh
   kubectl run testpod1 --image=nginx:latest --dry-run=client -o yaml
   ```
   *Note:* This generates the YAML manifest without creating the pod.

2. **Declarative Approach (Using YAML or JSON):**
   Create a file `pod.yaml` with the following content:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: testpod1
   spec:
     containers:
     - name: nginx
       image: nginx:latest
   ```
   Apply the manifest:
   ```sh
   kubectl apply -f pod.yaml
   ```

3. **Run Pod Directly:**
   ```sh
   kubectl run testpod1 --image=nginx:latest
   ```

4. **Get Pods:**
   ```sh
   kubectl get pods
   ```

---

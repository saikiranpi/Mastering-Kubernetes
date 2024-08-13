![a-3d-rendering-of-a-modern-futuristic-data-center--Zf8_hn_pRcyGryPlC5p7ng-QH0BY5aORJKea1KsqNyvCw](https://github.com/user-attachments/assets/6ea61135-120e-49f8-b5fb-29f52980ff8a)


Here’s an expanded description with additional details about networking:

---

## Kubernetes Network Policies with Calico

This repository contains a collection of YAML configuration files designed to manage and secure network traffic within a Kubernetes cluster using Calico. These network policies ensure controlled communication between different namespaces and environments, which is essential for maintaining the security and integrity of applications running in a microservices architecture.

### Features:

- **Namespace Isolation:**  
  Policies to isolate network traffic within specific namespaces, preventing unintended access between different parts of the cluster.

- **Granular Traffic Control:**  
  Define rules that allow or block traffic between namespaces, ensuring that only authorized communication paths are permitted.

- **Environment Segmentation:**  
  Securely manage traffic flow between development, QA, and production environments, helping to maintain a strict separation of concerns.

- **Ingress and Egress Management:**  
  Control incoming and outgoing traffic at a fine-grained level, which is crucial for both security and performance optimization.

- **Port-Specific Rules:**  
  Implement policies that allow or restrict traffic on specific TCP/UDP ports, such as allowing QA to communicate with production over a specific port.

### Files Included:

1. **0-deny-traffic-inside-namespace.yaml**  
   - Denies all traffic within a specific namespace, ensuring strict isolation.

2. **1-Creating-ns-pods-labels.yaml**  
   - Creates namespaces and applies necessary labels to pods for easier policy application.

3. **2-block-all-traffic-namespace.yaml**  
   - Blocks all incoming and outgoing traffic to and from a specific namespace, providing a secure baseline.

4. **3-Allow-Traffic-single-namespace.yaml**  
   - Allows internal traffic within a single namespace, enabling services within the namespace to communicate freely.

5. **4-allow-dev-to-prod-traffic.yaml**  
   - Permits traffic from the development namespace to the production namespace under controlled conditions.

6. **5-allow-prod-to-qa-tcp-8888.yaml**  
   - Allows communication from production to QA namespace over TCP port 8888, ensuring specific services can interact.

7. **6-allowing-coredns-ingress-prod.yaml**  
   - Allows ingress traffic to CoreDNS in the production namespace, ensuring that DNS services remain accessible.

### Script:

- **Calico.sh**  
  This script automates the application of the above network policies using Calico, simplifying the process of enforcing security rules within the Kubernetes cluster.

### How to Use:

1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/kubernetes-network-policies.git](https://github.com/saikiranpi/Mastering-Kubernetes)
   ```

2. Navigate to the directory:
   ```bash
   cd kubernetes-network-policies
   ```

3. Apply the desired network policy:
   ```bash
   kubectl apply -f 0-deny-traffic-inside-namespace.yaml
   ```

4. Run the `Calico.sh` script to apply all policies at once:
   ```bash
   bash Calico.sh
   ```

### Contributions

Contributions are welcome! Feel free to submit a pull request or open an issue to suggest improvements.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



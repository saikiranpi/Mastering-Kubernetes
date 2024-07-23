#!/bin/bash

# Array of folder names with day prefixes
folders=(
    "Day 01 KOPS-Deployment"
    "Day 02 PODs-ReplicaSets"
    "Day 03 Deployments"
    "Day 04 Services"
    "Day 05 IngressController-TLS-RegistrySecret-Probes"
    "Day 06 Sidecar-ResourceQuotas-Jobs-CronJobs"
    "Day 07 RBAC-Kubeconfig_Merge"
    "Day 08 Secrets-ESO-ConfigMaps"
    "Day 09 Storage-PV-PVC-DynamicProvisioning"
    "Day 10 NetworkPolicies"
    "Day 11 AdvanceScheduling"
    "Day 12 Istio-ServiceMesh"
    "Day 13 Prometheus-Grafana-EFK"
    "Day 14 AWS_EKS_Jenkins_Integration"
    "Day 15 ArgoCD"
    "Day 16 MetricsServer_VPA_HPA_Karpenter"
)

# Loop through the array and create each folder with a README.md file
for folder in "${folders[@]}"; do
    mkdir -p "$folder"
    touch "$folder/README.md"
done

echo "Folders and README.md files created successfully."

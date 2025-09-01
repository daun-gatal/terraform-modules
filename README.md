# Terraform Module

This Terraform module deploys resources to a Kubernetes cluster (i.e. Minikube).

---

## **Prerequisites**

Before using this module, ensure you have the following:

1. **Minikube running**
   - Install Minikube: https://minikube.sigs.k8s.io/docs/start/
   - Start a cluster:
     ```bash
     minikube start
     ```

2. **Tailscale account and Kubernetes Operator setup**
   - Follow the Tailscale Kubernetes operator setup guide:
     https://tailscale.com/kb/1236/kubernetes-operator#setup

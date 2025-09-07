# Terraform Module

This Terraform module deploys resources to a Kubernetes cluster (i.e., Minikube).

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
   - Add the Tailscale Helm repo and update:
     ```bash
     helm repo add tailscale https://pkgs.tailscale.com/helmcharts
     helm repo update
     ```
   - Install or upgrade the Tailscale operator:
     ```bash
     helm upgrade \
       --install \
       tailscale-operator \
       tailscale/tailscale-operator \
       --namespace=tailscale \
       --create-namespace \
       --set-string oauth.clientId="<OAuth client ID>" \
       --set-string oauth.clientSecret="<OAuth client secret>" \
       --wait
     ```
   - Follow the full setup guide: https://tailscale.com/kb/1236/kubernetes-operator#setup

3. **Apache Spark Kubernetes Operator**
   - The Spark Operator must be installed on your cluster to manage Spark applications.
   - Installation and setup guide:
     https://github.com/apache/spark-kubernetes-operator/tree/main
   - Example installation using Helm:
     ```bash
     helm repo add spark https://apache.github.io/spark-kubernetes-operator
     helm repo update
     helm install spark spark/spark-kubernetes-operator --namespace spark --create-namespace
     ```
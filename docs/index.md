---
hide:
  - navigation
  - toc
---



> **Engineering scalable, modular data platforms on Kubernetes.**
>
> This project demonstrates my approach to building production-grade infrastructure using Terraform. It showcases advanced composition patterns, secure secret management, and a standardized module interface.

[Explore Modules](modules/){ .md-button .md-button--primary }

---

## Lab Environment

These deployments are running live on my personal Kubernetes cluster, managed entirely by the modules in this repository.

<div class="grid cards" markdown>

-   :simple-apacheairflow: **Orchestration Layer**

    ---

    **Apache Airflow** configured with CeleryExecutor, git-sync for DAGs, and OIDC authentication.

    [:octicons-link-external-16: View Deployment](https://airflow-web-ext.kitty-barb.ts.net){ .md-button .md-button--primary }

-   :simple-apachesuperset: **Analytics Layer**

    ---

    **Apache Superset** connected to Trino and Postgres, demonstrating the full BI stack integration.

    [:octicons-link-external-16: View Deployment](https://superset-web-ext.kitty-barb.ts.net){ .md-button .md-button--primary }

-   :simple-apachekafka: **Streaming Layer**

    ---

    **Kafka Ecosystem** including Schema Registry and ksqlDB, managed via Kafka UI.

    [:octicons-link-external-16: View Deployment](https://kafka-ui-ext.kitty-barb.ts.net/){ .md-button .md-button--primary }

</div>

---

## Core Competencies

<div class="grid cards" markdown>

-   :material-server-network: **Platform Engineering**

    ---

    Abstracts complex Helm charts into standardized Terraform modules. This enables resource provisioning (Airflow, Trino) through simple, consistent interfaces without requiring deep Kubernetes expertise.

-   :material-kubernetes: **Kubernetes Operations**

    ---

    Demonstrates management of stateful workloads on K8s, handling persistent storage (PVCs), High Availability (StatefulSets), and secure ingress networking for sensitive data services.

-   :material-layers-triple: **Modern Data Stack**

    ---

    Integrates open-source tools into a cohesive platform. The "Lab Environment" connects orchestration (Airflow) directly with analytics (Superset).

</div>

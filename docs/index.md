---
hide:
  - navigation
  - toc
---

# Data Infrastructure Portfolio

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

## Technical Highlights

<div class="grid cards" markdown>

-   :material-puzzle-outline: **Modular Architecture**

    ---

    Designed with the **Exclusive Config Pattern**, strictly separating configuration inputs from resource instantiation. This allows modules (e.g., Postgres, MinIO) to be wired together cleanly without hardcoded dependencies, treating infrastructure as composable building blocks.

-   :material-cube-outline: **Standardized API Contract**

    ---

    Every module implements a consistent interface, exposing a uniform `config` object with `service_name`, `service_port`, and `internal_url`. This predictability simplifies consumption and reduces the cognitive load when collecting new components.

-   :material-security: **Zero-Trust Security**

    ---

    Security is engineered by default, not an afterthought. All sensitive credentials are managed via native Kubernetes Secrets and mapped directly to application environment variables. No secrets are ever exposed in plain text or Terraform state outputs.

-   :material-git: **GitOps Ready**

    ---

    The entire platform is designed for GitOps. Applications like Airflow and Superset are configured to sync DAGs and Dashboards directly from Git repositories, ensuring that the infrastructure state always matches the version-controlled definition.

</div>

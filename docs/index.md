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
[Design Philosophy](architecture.md){ .md-button }

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

-   :material-puzzle-outline: **Composition Pattern**
    ---
    Implemented the "Exclusive Config" pattern to separate configuration data from resource instantiation, allowing modules to be wired together like building blocks.

-   :material-cube-outline: **Standardized Interfaces**
    ---
    All 20+ modules adhere to a strict input/output contract (`service_name`, `service_port`, `internal_url`), simplifying cross-module dependencies.

-   :material-security: **Security Engineering**
    ---
    Zero-trust principles applied: explicit identity management, secrets injected via Kubernetes Secrets (never plain text), and network policies.

-   :material-chart-tree: **Full Stack Data Ops**
    ---
    A complete reference architecture covering Ingestion (Airbyte), Storage (MinIO, Postgres), Compute (Spark, Trino), and Viz (Superset).

</div>

---
layout: home
hero:
  name: "Data Engineering"
  text: "Infrastructure Showcase"
  tagline: "A comprehensive showcase of production-grade, composable Terraform modules for building scalable data platforms on Kubernetes."
  actions:
    - theme: brand
      text: Explore Modules
      link: /modules/orchestration/airflow
    - theme: alt
      text: View Source
      link: https://github.com/daun-gatal/terraform-modules
---

<ModuleExplorer view-mode="showcase" />

## Lab Environment

Live deployments managed by these modules.

<div class="project-grid">
  <a href="https://airflow-web-ext.kitty-barb.ts.net/" target="_blank" class="project-card">
    <h3>🌩️ Orchestration Layer</h3>
    <p><strong>Apache Airflow</strong> configured with CeleryExecutor, git-sync for DAGs, and OIDC authentication.</p>
  </a>
  <a href="https://superset-web-ext.kitty-barb.ts.net/login/" target="_blank" class="project-card">
    <h3>📊 Analytics Layer</h3>
    <p><strong>Apache Superset</strong> connected to Trino and Postgres, demonstrating the full BI stack integration.</p>
  </a>
  <a href="https://kafka-ui-ext.kitty-barb.ts.net/" target="_blank" class="project-card">
    <h3>🚀 Streaming Layer</h3>
    <p><strong>Kafka Ecosystem</strong> including Schema Registry and ksqlDB, managed via Kafka UI.</p>
  </a>
  <a href="https://clickhouse-studio-ext.kitty-barb.ts.net/" target="_blank" class="project-card">
    <h3>📉 OLAP Layer</h3>
    <p><strong>ClickHouse UI</strong> for real-time analytics.</p>
    <p><small>User: <code>guest</code> • Pass: <code>Guest123456!</code></small></p>
  </a>
</div>

## Core Competencies

<div class="project-grid">
  <div class="project-card">
    <h3>🏗️ Platform Engineering</h3>
    <p>Abstracts complex Helm charts into standardized Terraform modules. Enables resource provisioning through simple interfaces.</p>
  </div>
  <div class="project-card">
    <h3>☸️ Kubernetes Operations</h3>
    <p>Management of stateful workloads (PVCs, StatefulSets) and secure ingress networking.</p>
  </div>
  <div class="project-card">
    <h3>🛠️ Modern Data Stack</h3>
    <p>Integration of open-source tools into a cohesive platform, connecting orchestration directly with analytics.</p>
  </div>
</div>

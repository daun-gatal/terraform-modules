# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.6.0] - 2026-01-06

### Added
- **New Module**: `clickhouse` - Added comprehensive ClickHouse module with `keeper`, `server`, and `ui` submodules.
  - `keeper`: Deploys ClickHouse Keeper (ZooKeeper alternative) as a StatefulSet.
  - `server`: Deploys ClickHouse Server using the `ClickHouseInstallation` CRD (Altinity Operator).
  - `ui`: Deploys ClickHouse UI (via `ch-ui`) with optional Tailscale Funnel ingress support.
- **Operator Support**: Added support for `clickhouse-operator` (Altinity) in installation scripts.
- **Script Improvements**: Updates to `scripts/manage-operators.sh`:
  - Enforced "**latest by default**" versioning policy for all operators (Helm charts now pull latest unless specified).
  - Added modular flags (e.g., `--with-clickhouse`, `--with-strimzi`) and an `--all` flag for flexible installation.
  - Refactored into a modular function-based architecture for better maintainability.

### Changed
- **Defaults**: Updated default `storage_class` to `standard` and resource requests/limits to "dev-friendly" (very low) values across `clickhouse` submodules to ensure generic compatibility.

## [v0.5.0] - 2026-01-05

### Changed
- **hms**: Refactored configuration management to use `hive-site.xml` ConfigMap via template.
- **hms**: Switched to `apache/hive:3.1.3` and downgraded injected jars (`hadoop-aws-3.1.3`, `aws-java-sdk-bundle-1.11.271`, `guava-27.0-jre`) for compatibility.
- **hms**: Fixed Schema initialization by mounting driver libs to `/opt/hive/lib/ext` and prioritizing them in `HADOOP_CLASSPATH`.
- **hms**: Disabled SSL (`sslmode=disable`) for PostgreSQL connection to resolve protocol version mismatches.
- **hms**: Removed `EnvironmentVariableCredentialsProvider` and authorization listeners to fix start-up crashes.

## [v0.4.0] - 2026-01-04

### Added
- **New Module**: `hms` (Hive Metastore) - Standardized standalone Metastore deployment.

### Changed
- **BREAKING CHANGE**: Standardized `resources_config` variable structure across `airflow`, `hms`, `trino`, `superset`, and `dockge` modules.
  - Converted loose `map(object)` types to strict `object({ ... })` with component-specific keys (e.g., `scheduler`, `worker`, `coordinator`).
  - Updated internal resource access to use dot notation for better type safety and autocomplete.
  - This aligns these modules with the strict typing pattern used in `kafka`, `minio`, `nessie`, and others.

### Fixed
- **Dockge**: Fixed a bug where the `resources` variable was defined as a `map` but accessed as an `object` with `dockge` and `dind` keys in `main.tf`.

## [v0.3.0] - 2026-01-03

### Changed
- **BREAKING CHANGE**: Standardized module outputs across all 23 modules to strictly follow the **Exclusive Config** pattern.
  - All "standard" identifiers are now top-level outputs: `release_name`, `namespace`, `service_name`, `service_port`, and `ingress_host`.
  - All module-specific attributes (e.g., `root_user`, `jdbc_url`, `connection_string`) have been **MOVED** into the new `config` output object and **REMOVED** from the top level to prevent duplication.
  - Renamed legacy variable-specific outputs (e.g., `minio_service_dns`, `postgres_rw_dns`) to the standardized names.

### Added
- **Config Output**: Introduced a consistent `config` output object in every module.
  - Contains `internal_url` (standardized connection string).
  - Contains `attributes` map for all module-specific data (credentials, keys, detailed configuration).
- **New Outputs**: Created `outputs.tf` for modules that previously lacked them: `airbyte`, `airflow`, `dockge`, `kestra`, `metabase`, `superset`, `kafka/ui`, and `kafka/node`.

## [v0.2.4] - 2026-01-03

### Changed
- **Helm Provider**: Bumped `hashicorp/helm` provider version to `~> 3.1.1` across all modules.
- **Kubernetes Provider**: Bumped `hashicorp/kubernetes` provider version to `~> 3.0.1` across all modules.
- **Terraform Core**: Bumped required Terraform version to `>= 1.14.3` across all modules.

## [v0.2.3] - 2026-01-03

### Fixed
- **CI/CD**: Fixed `auto-tag` workflow to properly trigger GitHub Release creation by merging workflows.

## [v0.2.2] - 2026-01-03

### Added
- **CI/CD**: Added `auto-tag` workflow to automate release tagging.

## [v0.2.1] - 2026-01-03

### Added
- **CI/CD**: Added `docs.yaml` workflow to validate module documentation using `terraform-docs` v0.21.0.
- **Documentation**: Standardized all module READMEs using `terraform-docs` and `markdown table` format. Added `terraform-docs` configuration file `.terraform-docs.yml`.

### Changed
- **Documentation**: Updated `gravitino` and `kafka` parent READMEs to include navigation to sub-modules.
- **Documentation**: Added workflow status badges to root `README.md`.

## [v0.2.0] - 2026-01-03

### Added
- **CI/CD Workflows**: Added comprehensive GitHub Actions pipelines (`lint.yaml`, `docs.yaml`, `security.yaml`, `scripts.yaml`) running on **self-hosted** runners.
- **Documentation**: Added standardized `README.md` files for all modules with auto-generated input/output tables.
- **Root Documentation**: Overhauled root `README.md` with architecture diagrams, quick start guides, and status badges.
- **Linting Config**: Added `.tflint.hcl` with optimized rules (`terraform_documented_variables`, `terraform_module_pinned_source`).
- **Script Improvements**: Added robust error handling (`set -euo pipefail`), usage help, and dependency checks to `create-namespaces.sh` and `manage-operators.sh`.

### Changed
- **Standardization**: Renamed all `output.tf` files to `outputs.tf` across the codebase.
- **Helm Provider**: Updated `hashicorp/helm` provider version to `~> 2.16` across all modules to resolve compatibility issues.
- **Documentation Cleanup**: Removed manual "Inputs/Outputs" tables from module READMEs to prevent conflicts with `terraform-docs`.

### Security
- **Sensitive Variables**: Marked password and secret variables as `sensitive = true` in `nessie`, `minio`, `airflow`, `lakekeeper`, `superset`, `metabase`, and `rustfs`.
- **Infrastructure Scanning**: Integrated Trivy IaC scanning into the CI pipeline.

## [v0.1.0] - 2025-12-31

### Added
- Initial release of modular data platform components.
- Modules: `postgres`, `minio`, `airflow`, `kafka`, `trino`, `superset`, `metabase`, `keycloak`, `openbao`, `gravitino`, `nessie`, `lakekeeper`, `rustfs`, `airbyte`, `dockge`, `kestra`.

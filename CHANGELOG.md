# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

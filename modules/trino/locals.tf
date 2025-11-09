locals {
  prefix = var.prefix
  release_name = "${local.prefix}-release"

  coordinator_resources_requests_cpu = var.trino_resources_config["coordinator"].requests.cpu
  coordinator_resources_requests_ram = var.trino_resources_config["coordinator"].requests.ram
  coordinator_resources_limits_cpu   = var.trino_resources_config["coordinator"].limits.cpu
  coordinator_resources_limits_ram   = var.trino_resources_config["coordinator"].limits.ram

  worker_resources_requests_cpu = var.trino_resources_config["worker"].requests.cpu
  worker_resources_requests_ram = var.trino_resources_config["worker"].requests.ram
  worker_resources_limits_cpu   = var.trino_resources_config["worker"].limits.cpu
  worker_resources_limits_ram   = var.trino_resources_config["worker"].limits.ram

  rendered_catalogs = {
    for catalog in var.enabled_catalogs :
    "catalogs.${catalog.name}" =>
    templatefile("${path.module}/templates/catalog.tpl", {
      params = catalog.params
    })
  }

  catalogs_rules = flatten([
    for entry in var.trino_access_control_entries : [
      for cat in entry.catalogs : merge(
        {},
        entry.user  != null ? { user  = entry.user } : {},
        entry.role  != null ? { role  = entry.role } : {},
        entry.group != null ? { group = entry.group } : {},
        cat.allow   != null ? { allow = cat.allow } : {},
        cat.catalog != null ? { catalog = cat.catalog } : {}
      )
    ]
  ])

  schemas_rules = flatten([
    for entry in var.trino_access_control_entries : [
      for sch in entry.schemas : merge(
        {},
        entry.user  != null ? { user  = entry.user } : {},
        entry.role  != null ? { role  = entry.role } : {},
        entry.group != null ? { group = entry.group } : {},
        sch.owner   != null ? { owner = sch.owner } : {},
        sch.catalog != null ? { catalog = sch.catalog } : {},
        sch.schema  != null ? { schema  = sch.schema } : {}
      )
    ]
  ])

  tables_rules = flatten([
    for entry in var.trino_access_control_entries : [
      for tbl in entry.tables : merge(
        {},
        entry.user  != null ? { user  = entry.user } : {},
        entry.role  != null ? { role  = entry.role } : {},
        entry.group != null ? { group = entry.group } : {},
        tbl.catalog    != null ? { catalog    = tbl.catalog } : {},
        tbl.schema     != null ? { schema     = tbl.schema } : {},
        tbl.table      != null ? { table      = tbl.table } : {},
        tbl.privileges != null ? { privileges = tbl.privileges } : {}
      )
    ]
  ])
}
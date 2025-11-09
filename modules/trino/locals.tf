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
      for c in entry.catalogs : {
        user    = entry.user
        role    = entry.role
        group   = entry.group
        catalog = lookup(c, "catalog", ".*")
        allow   = c.allow
      }
    ]
  ])

  schemas_rules = flatten([
    for entry in var.trino_access_control_entries : [
      for s in entry.schemas : {
        user    = entry.user
        role    = entry.role
        group   = entry.group
        catalog = lookup(s, "catalog", ".*")
        schema  = lookup(s, "schema", ".*")
        owner   = s.owner
      }
    ]
  ])

  tables_rules = flatten([
    for entry in var.trino_access_control_entries : [
      for t in entry.tables : {
        user               = entry.user
        role               = entry.role
        group              = entry.group
        catalog            = lookup(t, "catalog", ".*")
        schema             = lookup(t, "schema", ".*")
        table              = lookup(t, "table", ".*")
        privileges         = t.privileges
      }
    ]
  ])

  access_control_json = templatefile("${path.module}/templates/access_control.tpl", {
    catalogs = local.catalogs_rules
    schemas  = local.schemas_rules
    tables   = local.tables_rules
  })
}
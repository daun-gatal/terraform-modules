type: configmap
refreshPeriod: 60s
configFile: rules.json
rules:
  rules.json: |
    {{ yamlencode(catalogs = catalogs, schemas = schemas, tables = tables) }}

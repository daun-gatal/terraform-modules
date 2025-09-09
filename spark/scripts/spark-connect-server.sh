#!/bin/bash

# Spark Connect Server startup script
# This script starts the Spark Connect Server with the specified configuration

set -euo pipefail

echo "Starting Spark Connect Server..."
echo "Master URL: ${master_url}"
echo "Executor Memory: ${executor_memory}"
echo "Executor Cores: ${executor_cores}"
echo "Max Cores: ${max_cores}"

exec /opt/spark/bin/spark-submit \
  --class org.apache.spark.sql.connect.service.SparkConnectServer \
  --name 'Spark Connect Server' \
  --master "${master_url}" \
  --conf "spark.executor.memory=${executor_memory}" \
  --conf "spark.executor.cores=${executor_cores}" \
  --conf "spark.cores.max=${max_cores}" \
  --conf "spark.dynamicAllocation.enabled=false"

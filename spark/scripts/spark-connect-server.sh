#!/bin/bash

# Spark Connect Server startup script
# This script starts the Spark Connect Server with the specified configuration

set -euo pipefail

SPARK_HOME=$${SPARK_HOME:-/opt/spark}

# Detect Spark version
SPARK_VERSION=$$($SPARK_HOME/bin/spark-submit --version 2>&1 | \
  grep -oE "version [3-9]\.[0-9]+\.[0-9]+" | head -n1 | awk '{print $2}')
echo "Detected Spark version: $SPARK_VERSION"

SPARK_MAJOR=$$(echo "$SPARK_VERSION" | cut -d. -f1)

echo "Master URL: ${master_url}"
echo "Executor Memory: ${executor_memory}"
echo "Executor Cores: ${executor_cores}"
echo "Max Cores: ${max_cores}"

if [ "$SPARK_MAJOR" -lt 4 ]; then
  echo "Using Spark < 4. Adding spark-connect package..."
  exec "$SPARK_HOME/sbin/start-connect-server.sh" \
    --packages "org.apache.spark:spark-connect_2.12:$${SPARK_VERSION}" \
    --name 'Spark Connect Server' \
    --conf "spark.executor.memory=${executor_memory}" \
    --conf "spark.executor.cores=${executor_cores}" \
    --conf "spark.cores.max=${max_cores}" \
    --conf "spark.dynamicAllocation.enabled=false"
else
  echo "Using Spark >= 4. Running current Spark Connect script..."
  exec $SPARK_HOME/bin/spark-submit \
    --class org.apache.spark.sql.connect.service.SparkConnectServer \
    --name 'Spark Connect Server' \
    --master "${master_url}" \
    --conf "spark.executor.memory=${executor_memory}" \
    --conf "spark.executor.cores=${executor_cores}" \
    --conf "spark.cores.max=${max_cores}" \
    --conf "spark.dynamicAllocation.enabled=false"
fi
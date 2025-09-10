#!/bin/bash

# Spark Connect Server startup script
# This script starts the Spark Connect Server with the specified configuration

set -euo pipefail

echo "Starting Spark Connect Server..."

# Detect Spark version
SPARK_VERSION=$(cat $$SPARK_HOME/RELEASE 2>/dev/null | grep "Spark " | cut -d' ' -f2 || echo "unknown")
SPARK_MAJOR_VERSION=$(echo $$SPARK_VERSION | cut -d'.' -f1)

echo "Detected Spark version: $$SPARK_VERSION"
echo "Master URL: ${master_url}"
echo "Executor Memory: ${executor_memory}"
echo "Executor Cores: ${executor_cores}"
echo "Max Cores: ${max_cores}"

# Build Spark configuration
SPARK_CONF=(
    --class org.apache.spark.sql.connect.service.SparkConnectServer
    --name "Spark Connect Server"
    --master "${master_url}"
    --conf "spark.executor.memory=${executor_memory}"
    --conf "spark.executor.cores=${executor_cores}"
    --conf "spark.cores.max=${max_cores}"
    --conf "spark.dynamicAllocation.enabled=false"
    --conf "spark.sql.connect.grpc.binding.port=15002"
    --conf "spark.sql.connect.grpc.binding.host=0.0.0.0"
)

# Version-specific configuration
if [[ "$$SPARK_MAJOR_VERSION" == "4" ]]; then
    echo "Using Spark 4.x configuration..."
elif [[ "$$SPARK_MAJOR_VERSION" == "3" ]]; then
    echo "Using Spark 3.x configuration..."
    SPARK_CONF+=(
        --packages "org.apache.spark:spark-connect_2.12:$$SPARK_VERSION"
    )
fi

echo "Starting Spark Connect Server..."
exec /opt/spark/bin/spark-submit "${SPARK_CONF[@]}"
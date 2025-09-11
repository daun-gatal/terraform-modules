#!/bin/bash
set -euo pipefail

# Airflow Scheduler Initialization Script
# Sets up MinIO connection if remote logging is enabled, then starts scheduler

echo "Starting Airflow Scheduler initialization..."

# Check if remote logging is enabled
if [ "$AIRFLOW__LOGGING__REMOTE_LOGGING" = "True" ]; then
    echo "Remote logging is enabled. Setting up MinIO connection..."
    
    # Add MinIO connection for remote logging
    airflow connections add minio_conn \
        --conn-type 'aws' \
        --conn-login '${aws_access_key_id}' \
        --conn-password '${aws_secret_access_key}' \
        --conn-extra "{\"region_name\": \"${aws_region}\", \"endpoint_url\": \"${aws_endpoint_url}\"}" \
        || echo "MinIO connection already exists or failed to create (continuing anyway)"
    
    echo "✅ MinIO connection configured for remote logging"
else
    echo "Remote logging is disabled. Skipping MinIO connection setup."
fi

echo "🚀 Starting Airflow Scheduler..."
exec airflow scheduler

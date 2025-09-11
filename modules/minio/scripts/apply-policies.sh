#!/bin/sh
set -euo pipefail

MINIO_ENDPOINT="http://${tenant_name}-hl.${namespace}.svc.cluster.local:9000"
MINIO_ROOT_USER="${username}"
MINIO_ROOT_PASSWORD="${password}"

echo "Waiting for MinIO API to be accessible at $MINIO_ENDPOINT..."

MAX_RETRIES=30
RETRY_COUNT=0
RETRY_INTERVAL=10 # seconds

# Wait for MinIO to be ready
until mc alias set myminio "$MINIO_ENDPOINT" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" 2>/dev/null; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -gt $MAX_RETRIES ]; then
    echo "Failed to connect to MinIO after $MAX_RETRIES attempts."
    exit 1
  fi
  echo "Attempt $RETRY_COUNT/$MAX_RETRIES: MinIO not ready, waiting $RETRY_INTERVAL seconds..."
  sleep $RETRY_INTERVAL
done

echo "Successfully connected to MinIO!"

# Apply lifecycle rules for each bucket
%{~ for bucket in buckets ~}
%{~ if bucket.expire_days != null || bucket.noncurrent_expire_days != null ~}
echo "Setting lifecycle rule for bucket: ${bucket.name}"

  # Execute the command directly based on what parameters are available
  %{~ if bucket.expire_days != null && bucket.noncurrent_expire_days != null ~}
  echo "Running: mc ilm rule add --expire-days ${bucket.expire_days} --noncurrent-expire-days ${bucket.noncurrent_expire_days} myminio/${bucket.name}"
  mc ilm rule add --expire-days ${bucket.expire_days} --noncurrent-expire-days ${bucket.noncurrent_expire_days} myminio/${bucket.name}
  %{~ else ~}
  %{~ if bucket.expire_days != null ~}
  echo "Running: mc ilm rule add --expire-days ${bucket.expire_days} myminio/${bucket.name}"
  mc ilm rule add --expire-days ${bucket.expire_days} myminio/${bucket.name}
  %{~ endif ~}
  %{~ if bucket.noncurrent_expire_days != null ~}
  echo "Running: mc ilm rule add --noncurrent-expire-days ${bucket.noncurrent_expire_days} myminio/${bucket.name}"
  mc ilm rule add --noncurrent-expire-days ${bucket.noncurrent_expire_days} myminio/${bucket.name}
  %{~ endif ~}
  %{~ endif ~}
  
  if [ $? -eq 0 ]; then
      echo "✅ Lifecycle rule applied to ${bucket.name}"
  else
      echo "❌ Failed to apply lifecycle rule to ${bucket.name}"
      exit 1
  fi

%{~ else ~}
echo "Skipping bucket ${bucket.name} - no lifecycle configuration specified"
%{~ endif ~}
%{~ endfor ~}

echo "All lifecycle rules applied successfully!"
echo "Current bucket list:"
mc ls myminio/

echo "Lifecycle rules status:"
%{~ for bucket in buckets ~}
echo "=== Bucket: ${bucket.name} ==="
mc ilm ls myminio/${bucket.name} || echo "No lifecycle rules found"
%{~ endfor ~}
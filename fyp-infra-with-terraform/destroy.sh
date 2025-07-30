#!/bin/bash

# Script to properly destroy all resources
echo "Starting cleanup and destroy process..."

# Get bucket and repository names
BUCKET_NAME=$(terraform output -raw artifacts_bucket_name 2>/dev/null || echo "")
ECR_REPO=$(terraform output -raw ecr_repository_name 2>/dev/null || echo "")

# Clean up S3 bucket (no versioning)
if [ ! -z "$BUCKET_NAME" ]; then
    echo "Emptying S3 bucket: $BUCKET_NAME"
    aws s3 rm s3://$BUCKET_NAME --recursive || true
fi

# Clean up ECR repository (force delete)
if [ ! -z "$ECR_REPO" ]; then
    echo "Force deleting ECR repository: $ECR_REPO"
    aws ecr delete-repository --repository-name $ECR_REPO --force || true
fi

# Now run terraform destroy
echo "Running terraform destroy..."
terraform destroy -auto-approve

echo "Cleanup and destroy completed!"
# Null resource to clean up resources before destroy
resource "null_resource" "cleanup" {
  triggers = {
    s3_bucket = aws_s3_bucket.artifacts.bucket
    ecr_repo  = aws_ecr_repository.app.name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Empty S3 bucket (no versioning)
      aws s3 rm s3://${self.triggers.s3_bucket} --recursive || true
      
      # Force delete ECR repository with all images
      aws ecr delete-repository --repository-name ${self.triggers.ecr_repo} --force || true
    EOT
  }
}
# CodePipeline webhook for GitHub
resource "aws_codepipeline_webhook" "github" {
  name            = "${var.project_name}-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.app.name

  authentication_configuration {
    secret_token = random_string.webhook_secret.result
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.github_branch}"
  }

  tags = var.tags
}

# Random string for webhook secret
resource "random_string" "webhook_secret" {
  length  = 32
  special = false
}

# GitHub webhook creation
resource "null_resource" "github_webhook" {
  depends_on = [aws_codepipeline_webhook.github]
  
  triggers = {
    webhook_url = aws_codepipeline_webhook.github.url
    secret      = random_string.webhook_secret.result
  }

  provisioner "local-exec" {
    command = <<-EOF
      curl -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${var.github_token}" \
        -d '{
          "name": "web",
          "active": true,
          "events": ["push"],
          "config": {
            "url": "${aws_codepipeline_webhook.github.url}",
            "content_type": "json",
            "secret": "${random_string.webhook_secret.result}",
            "insecure_ssl": "0"
          }
        }' \
        https://api.github.com/repos/${var.github_owner}/${var.github_repo}/hooks
    EOF
  }
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "fyp-cicd"
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub repository branch"
  type        = string
  default     = "main"
}

variable "github_token" {
  description = "GitHub personal access token for webhook creation"
  type        = string
  sensitive   = true
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for the ALB target group"
  type        = string
  default     = "/"
}

variable "task_cpu" {
  description = "CPU units for the ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 256 # 0.25 vCPU
}

variable "task_memory" {
  description = "Memory for the ECS task in MiB"
  type        = number
  default     = 512 # 0.5 GB
}

variable "service_desired_count" {
  description = "Number of tasks to run in the ECS service"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "fyp-cicd"
    ManagedBy   = "terraform"
  }
}
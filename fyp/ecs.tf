# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = var.tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  
  container_definitions = jsonencode([{
    name         = var.project_name
    image        = "${aws_ecr_repository.app.repository_url}:latest"
    essential    = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
  
  tags = var.tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
  
  tags = var.tags
}

# ECS Service
resource "aws_ecs_service" "app" {
  name                               = "${var.project_name}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = var.service_desired_count
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  health_check_grace_period_seconds  = 60
  
  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }
  
  deployment_controller {
    type = "ECS"
  }
  
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  
  depends_on = [aws_lb_listener.http]
  
  tags = var.tags
}
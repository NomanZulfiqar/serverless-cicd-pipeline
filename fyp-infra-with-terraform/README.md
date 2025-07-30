# Serverless CI/CD Pipeline with Docker and Kubernetes on AWS

This project implements a fully serverless CI/CD pipeline using AWS services that allows developers to commit code to GitHub and automatically deploy it to ECS Fargate.

## Architecture

```
GitHub Repository → CodePipeline → CodeBuild → ECR → ECS Fargate → ALB
```

## Components

- **GitHub**: Source code repository
- **AWS CodePipeline**: Orchestrates the CI/CD workflow
- **AWS CodeBuild**: Builds Docker images
- **Amazon ECR**: Stores Docker images
- **Amazon ECS Fargate**: Runs containers without managing servers
- **Application Load Balancer**: Routes traffic to containers

## Prerequisites

- AWS Account
- GitHub Repository
- Terraform installed locally
- AWS CLI configured

## Setup Instructions

1. Clone this repository
2. Create a `terraform.tfvars` file based on the example
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Apply the Terraform configuration:
   ```
   terraform apply
   ```
5. Complete the GitHub connection in the AWS Console
6. Push code to your GitHub repository to trigger the pipeline

## Important Notes

- After applying Terraform, you need to manually complete the GitHub connection in the AWS Console
- The first pipeline run will fail until the GitHub connection is completed
- The ALB DNS name will be provided in the Terraform outputs

## Clean Up

To destroy all resources created by this project:

```
terraform destroy
```

## Future Enhancements

- Add HTTPS support with ACM
- Implement Blue/Green deployments
- Add monitoring and alerting
- Implement Kubernetes (EKS) deployment option
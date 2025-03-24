# Simple Webserver on AWS

This project deploys a simple Nginx webserver on AWS using ECS Fargate with HTTPS, Auth0 authentication, and proper infrastructure security. The application is accessible at https://simple-webserver.tlservers.net/.

## Architecture Overview

This infrastructure consists of:

- **AWS ECS Fargate** hosting an Nginx container
- **Application Load Balancer** for traffic distribution and HTTPS termination
- **Auth0 Integration** for secure authentication
- **AWS ACM** for SSL certificate management
- **Route53** for DNS management
- **VPC** with public and private subnets across two availability zones

## Infrastructure Components

### Networking
- VPC with CIDR block `10.0.0.0/16`
- 2 public subnets in `eu-west-1a` and `eu-west-1b`
- 2 private subnets in `eu-west-1a` and `eu-west-1b`
- NAT Gateway for outbound connectivity from private subnets
- Security groups for the load balancer and ECS tasks

### Container Infrastructure
- ECS Fargate cluster
- ECS task definition for Nginx container
- ECS service with public IP assignment
- Task role with ECS Exec capability for debugging

### Security & Authentication
- HTTPS-only access with HTTP to HTTPS redirection
- Auth0 OIDC authentication
- ACM certificate with DNS validation
- Secure session management

### Load Balancing
- Application Load Balancer with HTTP to HTTPS redirection
- Target group for the ECS tasks
- Authentication rules and callback handling

## Prerequisites

- Terraform >= 1.10.4
- AWS CLI configured with `sandbox-aws-admin` profile
- Auth0 client credentials

## Deployment

1. Clone this repository
2. Create a `terraform.tfvars` file with the required Auth0 credentials:

```hcl
auth0_client_id     = "your-auth0-client-id"
auth0_client_secret = "your-auth0-client-secret"
```

3. Initialize Terraform:

```bash
terraform init
```

4. Plan the deployment:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

## Authentication Flow

1. User accesses https://simple-webserver.tlservers.net/
2. They are redirected to Auth0 for authentication
3. After successful authentication, Auth0 redirects back to the `/oauth2/idpresponse` endpoint
4. The load balancer sets a session cookie and forwards the request to the Nginx container

## Operational Notes

### Accessing the Container

To access the running container using ECS Exec:

```bash
aws ecs execute-command \
  --cluster simple_webserver_cluster \
  --task <task-id> \
  --container simple_webserver \
  --command "/bin/bash" \
  --interactive \
  --profile sandbox-aws-admin
```

### Certificate Renewal

The ACM certificate is managed by Terraform with automatic DNS validation. The certificate has a `create_before_destroy` lifecycle policy to ensure smooth renewals.

## Resource Tags

All resources in this project are tagged with:

```
owner = "torsten"
```

## File Structure

- `main.tf` - Provider configuration
- `network.tf` - VPC, subnets, security groups, and load balancer configuration
- `ecs.tf` - ECS cluster, task definition, and service configuration
- `acm.tf` - Certificate and DNS validation configuration
- `variables.tf` - Input variable definitions
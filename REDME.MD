# Roy-Matan Status Page

A containerized, highly available, and secure implementation of the [Status-Page](https://github.com/Status-Page/Status-Page) open-source project, deployed on AWS infrastructure using modern DevOps practices.

## Table of Contents
- [Introduction](#introduction)
- [Architecture Overview](#architecture-overview)
- [Infrastructure Components](#infrastructure-components)
- [CI/CD Pipeline](#cicd-pipeline)
- [Containerization](#containerization)
- [Security Features](#security-features)
- [High Availability Design](#high-availability-design)
- [Monitoring and Logging](#monitoring-and-logging)
- [Deployment Instructions](#deployment-instructions)
- [Future Roadmap](#future-roadmap)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project is a containerized implementation of the [Status-Page](https://github.com/Status-Page/Status-Page) open-source status page software, with custom infrastructure, CI/CD pipeline, and deployment architecture. While the core application code is based on the original Status-Page project, the containerization, infrastructure as code, and deployment architecture are custom implementations by Roy Sahar and Matan Baron.

The project aims to provide a robust, scalable, and secure status page solution that can be easily deployed and maintained in AWS environments. It leverages modern DevOps practices, infrastructure as code, and containerization to achieve these goals.

This repository serves as a proof of concept (POC) that demonstrates the implementation of the Status-Page application in a production-ready environment. While not all planned features are fully implemented yet, the core functionality is working and ready for presentation.

## Architecture Overview

The architecture follows a modern cloud-native approach with separate staging and production environments, containerized applications, and infrastructure as code principles.

### High-Level Architecture

The system is deployed across multiple AWS services with a focus on security, scalability, and high availability:

- **Multi-VPC Architecture**: Separate VPCs for production and staging environments
- **Containerized Application**: Running on ECS clusters with task definitions
- **Database Layer**: PostgreSQL RDS instances for persistent storage
- **Caching Layer**: ElastiCache Redis for performance optimization
- **Load Balancing**: Application Load Balancers (ALB) for traffic distribution
- **Security**: WAF, security groups, and VPC endpoints for secure access
- **Monitoring**: CloudWatch for metrics, logs, and alerts

### Environment Separation

The infrastructure is deployed in two separate environments:

1. **Production Environment**: Hosts the live status page service
2. **Staging Environment**: Used for testing and validation before production deployment

Both environments mirror each other in structure but may differ in scaling parameters and resource allocation.

## Infrastructure Components

### AWS Services Used

The project leverages the following AWS services:

- **Amazon ECS**: Container orchestration
- **Amazon RDS**: PostgreSQL database
- **Amazon ElastiCache**: Redis caching
- **Amazon ALB**: Load balancing
- **Amazon ECR**: Container registry
- **Amazon VPC**: Network isolation
- **Amazon CloudWatch**: Monitoring and logging
- **AWS Secrets Manager**: Secure secrets storage
- **AWS Certificate Manager**: SSL/TLS certificate management
- **Amazon S3**: Terraform state storage

### VPC Architecture

Each environment (production and staging) has its own VPC with the following components:

- **Public Subnets**: Hosting ALBs across multiple Availability Zones
- **Private Subnets**: Hosting ECS services, RDS, and ElastiCache
- **VPC Endpoints**: For secure access to AWS services without internet exposure
- **Internet Gateway**: For public-facing services
- **Security Groups**: For fine-grained access control

### ECS Clusters

The application runs on ECS clusters with the following configuration:

- **Production ECS Cluster**: Hosts the public status page service and dashboard service
- **Staging ECS Cluster**: Mirrors production for testing and validation
- **Task Definitions**: Define container configurations, resource allocations, and environment variables
- **Service Definitions**: Manage deployment, scaling, and load balancing

### Database (RDS PostgreSQL)

The application uses PostgreSQL RDS instances for data persistence:

- **Multi-AZ Deployment**: For high availability
- **Automated Backups**: For data protection
- **Parameter Groups**: Optimized for the Status Page application
- **Security Groups**: Restricted access from ECS services only

### Caching (ElastiCache Redis)

Redis is used for caching and session management:

- **Replication**: For high availability
- **Automatic Failover**: For resilience
- **Parameter Groups**: Optimized for the Status Page application
- **Security Groups**: Restricted access from ECS services only

### Load Balancing (ALB)

Application Load Balancers distribute traffic and provide SSL termination:

- **Multiple Target Groups**: For different services
- **Health Checks**: For automatic failover
- **SSL/TLS Termination**: Using AWS Certificate Manager
- **WAF Integration**: For security

### Networking and Security Groups

The network architecture is designed with security in mind:

- **Layered Security Groups**: Restricting access between components
- **Private Subnets**: For sensitive components
- **Public Subnets**: Only for load balancers
- **NACLs**: For additional network security

### VPC Endpoints

VPC Endpoints are used for secure access to AWS services:

- **ECR VPC Endpoint**: For container image pulls
- **Secrets VPC Endpoint**: For secure access to secrets
- **CloudWatch VPC Endpoint**: For logs and metrics

## CI/CD Pipeline

The CI/CD pipeline is implemented using GitHub Actions and follows a structured workflow for building, testing, and deploying the application.

### GitHub Actions Workflow

The workflow is defined in `.github/workflows/main.yml` and includes the following stages:

1. **Code Testing**: Run automated tests on the codebase
2. **Build Stage**: 
   - Build Docker image
   - Run security scans
   - Tag image with version
   - Push image to ECR

3. **Staging Deployment**:
   - Deploy to staging environment
   - Run integration tests
   - Run load tests
   - Run miscellaneous tests

4. **Manual Approval**: Required before production deployment

5. **Production Deployment**: Deploy to production environment

### Build and Test Process

The build process includes:

- Checkout of the repository
- Configuration of AWS credentials
- Building the Docker image
- Running security scans on the image
- Tagging the image with a unique identifier
- Pushing the image to ECR

### Security Scanning

Security scanning is integrated into the CI/CD pipeline:

- Container image scanning for vulnerabilities
- Code scanning for security issues
- Dependency scanning for known vulnerabilities

### Deployment Stages

The deployment process follows these stages:

1. **Staging Deployment**: Automated deployment to the staging environment
2. **Testing**: Automated tests run against the staging environment
3. **Manual Approval**: Required before proceeding to production
4. **Production Deployment**: Deployment to the production environment

### Manual Approval Process

A manual approval step is required before deploying to production:

- Ensures human verification of changes
- Prevents accidental deployments
- Allows for final validation of the staging environment

### Infrastructure as Code Integration

The CI/CD pipeline integrates with Terraform for infrastructure management:

- Terraform initialization
- Terraform plan with debug output
- Terraform apply for infrastructure changes
- Infrastructure validation

## Containerization

The application is containerized using Docker, providing consistency across environments and simplified deployment.

### Docker Implementation

The Docker implementation is defined in the `app/dockerfile`:

- Based on Python 3.10 slim image
- Includes all necessary dependencies
- Creates a non-root user for security
- Sets up proper permissions
- Configures entrypoint and command

### Container Architecture

The container architecture includes:

- Status Page application container
- Proper environment variable configuration
- Volume mounts for persistent data
- Health checks for monitoring
- Resource limits for stability

### Image Management

Container images are managed through:

- Automated builds in the CI/CD pipeline
- Versioned tags for traceability
- Security scanning before deployment
- Proper cleanup of old images

### ECR Integration

Amazon ECR is used for container image storage:

- Secure image repository
- Integration with ECS for deployment
- Image scanning for vulnerabilities
- Lifecycle policies for image management

## Security Features

Security is a core consideration in the architecture and implementation.

### Network Security

Network security measures include:

- VPC isolation with public and private subnets
- Security groups with least privilege access
- NACLs for additional network protection
- VPC endpoints for AWS service access without internet exposure

### Secrets Management

Sensitive information is managed securely:

- AWS Secrets Manager for storing secrets
- Integration with ECS for secure access
- Rotation policies for credentials
- Least privilege access to secrets

### IAM Roles and Policies

IAM is configured following the principle of least privilege:

- Task execution roles for ECS
- Service roles for specific AWS services
- Custom policies for fine-grained access control
- No hardcoded credentials

### Security Groups

Security groups are configured to restrict access:

- ALB security groups allow only HTTP/HTTPS traffic
- ECS security groups allow only traffic from ALB
- Database security groups allow only traffic from ECS
- ElastiCache security groups allow only traffic from ECS

### WAF Implementation

Web Application Firewall protects the application:

- Protection against common web exploits
- IP-based access control
- Rate limiting to prevent abuse
- Custom rules for application-specific protection

## High Availability Design

The architecture is designed for high availability and resilience.

### Multi-AZ Deployment

Resources are deployed across multiple Availability Zones:

- ECS tasks distributed across AZs
- RDS with Multi-AZ configuration
- ElastiCache with replication across AZs
- ALB with cross-zone load balancing

### Load Balancing

Load balancing ensures even distribution of traffic:

- Application Load Balancers for HTTP/HTTPS traffic
- Health checks for automatic failover
- Cross-zone load balancing for resilience
- Connection draining for graceful shutdowns

### Auto-scaling

Auto-scaling ensures capacity meets demand:

- ECS service auto-scaling based on CPU/memory utilization
- Target tracking scaling policies
- Scheduled scaling for predictable patterns
- Step scaling for rapid response to load changes

### Disaster Recovery

Disaster recovery mechanisms include:

- Automated RDS backups
- Point-in-time recovery
- Cross-region replication (planned)
- Backup and restore procedures

## Monitoring and Logging

Comprehensive monitoring and logging are implemented for observability.

### CloudWatch Integration

CloudWatch is used for monitoring:

- Metrics collection from all components
- Custom metrics for application-specific monitoring
- Alarms for critical thresholds
- Dashboards for visualization

### Metrics Collection

Key metrics are collected and monitored:

- ECS service metrics (CPU, memory, task count)
- RDS metrics (connections, CPU, storage)
- ElastiCache metrics (memory, connections, cache hits)
- ALB metrics (request count, latency, error rates)

### Log Management

Logs are centralized and analyzed:

- ECS container logs sent to CloudWatch Logs
- RDS logs for database operations
- ALB access logs for request analysis
- VPC flow logs for network traffic analysis

### Alerting

Alerting is configured for critical events:

- CloudWatch Alarms for threshold breaches
- SNS for notification delivery
- Integration with incident management (planned)
- Escalation procedures

## Deployment Instructions

### Prerequisites

Before deployment, ensure you have:

- AWS account with appropriate permissions
- GitHub account for CI/CD pipeline
- Terraform installed locally for manual operations
- AWS CLI configured with appropriate credentials

### Initial Setup

1. Fork the repository
2. Configure AWS credentials as GitHub secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
3. Configure application secrets in AWS Secrets Manager
4. Update Terraform variables as needed

### Deployment Process

The deployment process is automated through the CI/CD pipeline:

1. Push changes to the main branch
2. GitHub Actions workflow will trigger
3. Code will be tested, built, and deployed to staging
4. Manual approval is required for production deployment
5. After approval, changes are deployed to production

### Environment Variables

The application requires several environment variables:

- Database connection parameters
- Redis connection parameters
- Application configuration
- Security settings

These are managed through AWS Secrets Manager and injected into the ECS task definitions.

## Future Roadmap

While the current implementation is functional as a POC, several enhancements are planned:

### Planned Features

- Cross-region replication for disaster recovery
- Enhanced monitoring and alerting
- Integration with incident management systems
- Automated database migrations
- Blue/green deployments

### Improvements

- Performance optimization
- Cost optimization
- Enhanced security measures
- Comprehensive documentation

### Known Limitations

- Some features are not fully implemented yet
- Performance testing is ongoing
- Documentation is being developed

## Contributing

Contributions to this project are welcome. Please follow these guidelines:

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Setup

1. Clone the repository
2. Install dependencies
3. Configure local environment
4. Run tests

## License

This project is based on the [Status-Page](https://github.com/Status-Page/Status-Page) open-source project, which is licensed under the Apache-2.0 license. Our custom implementations for containerization, infrastructure, and deployment are also licensed under the Apache-2.0 license.

### Original Status-Page License Acknowledgment

The core application code is based on the [Status-Page](https://github.com/Status-Page/Status-Page) project. Please refer to their license for more information.

---

Developed by Roy Sahar and Matan Baron

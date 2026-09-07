# 🚀 Production-Grade GitOps-Driven Microservices on AWS EKS

A hands-on DevOps and GitOps project demonstrating how to build, containerize, secure, deploy, monitor, and autoscale a microservices application on **Amazon EKS**.

The project combines:

- AWS
- Terraform
- Docker
- Kubernetes
- Amazon ECR
- GitHub Actions
- GitHub OIDC
- Trivy
- Argo CD
- Kustomize
- Prometheus
- Grafana
- Metrics Server
- Horizontal Pod Autoscaler

This repository is designed to be both:

1. A portfolio/project repository
2. A complete rebuild guide for the future

If the AWS environment is destroyed, the project can be recreated using this README and the Terraform configuration.

---

# 📑 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Project Objectives](#2-project-objectives)
3. [Architecture](#3-architecture)
4. [Technology Stack](#4-technology-stack)
5. [Repository Structure](#5-repository-structure)
6. [Microservices](#6-microservices)
7. [AWS Infrastructure](#7-aws-infrastructure)
8. [Terraform](#8-terraform)
9. [Amazon ECR](#9-amazon-ecr)
10. [Docker](#10-docker)
11. [Kubernetes](#11-kubernetes)
12. [Kustomize](#12-kustomize)
13. [Argo CD and GitOps](#13-argo-cd-and-gitops)
14. [GitHub Actions CI/CD](#14-github-actions-cicd)
15. [GitHub OIDC](#15-github-oidc)
16. [Trivy Security](#16-trivy-security)
17. [Observability](#17-observability)
18. [Prometheus](#18-prometheus)
19. [Grafana](#19-grafana)
20. [Metrics Server](#20-metrics-server)
21. [Horizontal Pod Autoscaler](#21-horizontal-pod-autoscaler)
22. [Important Problems and Solutions](#22-important-problems-and-solutions)
23. [Important Lessons Learned](#23-important-lessons-learned)
24. [Complete Rebuild Guide](#24-complete-rebuild-guide)
25. [Verification Checklist](#25-verification-checklist)
26. [Useful Commands](#26-useful-commands)
27. [Cleanup and Destroy](#27-cleanup-and-destroy)
28. [Security Guidelines](#28-security-guidelines)
29. [Production Improvements](#29-production-improvements)
30. [Interview Explanation](#30-interview-explanation)
31. [Project Status](#31-project-status)

---

# 1. Project Overview

This project deploys a microservices application on Amazon EKS using a GitOps-based deployment model.

The application is based on the **Online Boutique microservices application**.

The complete DevOps flow is:

```text
Developer
    |
    v
GitHub
    |
    v
GitHub Actions
    |
    +---- Detect Changed Services
    |
    +---- Build Docker Images
    |
    +---- Trivy Security Scan
    |
    +---- Push Images to ECR
    |
    +---- Update Kubernetes Image Tags
    |
    v
Git Repository
    |
    v
Argo CD
    |
    v
Amazon EKS
    |
    +---- Microservices
    |
    +---- Redis
    |
    +---- HPA
    |
    +---- Monitoring
            |
            +---- Prometheus
            |
            +---- Grafana
```

---

# 2. Project Objectives

The project was created to gain practical experience with a complete DevOps workflow.

## Main objectives

- Provision AWS infrastructure using Terraform
- Create a production-style VPC
- Deploy Amazon EKS
- Run worker nodes in private subnets
- Create Amazon ECR repositories
- Containerize microservices using Docker
- Deploy microservices to Kubernetes
- Automate builds using GitHub Actions
- Authenticate GitHub Actions with AWS using OIDC
- Scan container images with Trivy
- Implement GitOps using Argo CD
- Implement automated synchronization
- Test Argo CD self-healing
- Monitor EKS using Prometheus
- Visualize metrics using Grafana
- Collect Kubernetes resource metrics using Metrics Server
- Configure Horizontal Pod Autoscaling
- Document troubleshooting and rebuild procedures

---

# 3. Architecture

## 3.1 High-Level Application Architecture

```text
                           INTERNET
                              |
                              v
                     AWS Load Balancer
                              |
                              v
                  frontend-external Service
                              |
                              v
                       Frontend Pods
                              |
        +---------------------+---------------------+
        |           |          |          |         |
        v           v          v          v         v
      Cart       Checkout   Product    Currency  Recommendation
        |           |          |          |         |
        +-----------+----------+----------+---------+
                              |
                            Redis
```

---

## 3.2 CI/CD and GitOps Architecture

```text
                         Developer
                             |
                             v
                         GitHub
                             |
                             v
                    GitHub Actions
                             |
             +---------------+---------------+
             |               |               |
             v               v               v
       Detect Changes   Docker Build     Trivy Scan
                                             |
                                             v
                                      Security Gate
                                             |
                              +--------------+
                              |
                              v
                         Amazon ECR
                              |
                              v
                       GitOps Update
                              |
                              v
                           Argo CD
                              |
                              v
                         Amazon EKS
```

---

## 3.3 AWS Network Architecture

```text
                         AWS Region
                        ap-south-1
                             |
                             v
                    +----------------+
                    |      VPC       |
                    | 10.0.0.0/16    |
                    +----------------+
                             |
              +--------------+--------------+
              |                             |
              v                             v
        Public Subnets                Private Subnets
        10.0.1.0/24                  10.0.11.0/24
        10.0.2.0/24                  10.0.12.0/24
              |                             |
              |                             v
              |                        EKS Workers
              |                             |
              v                             |
       Internet Gateway                    |
              |                             |
              v                             |
         NAT Gateway <----------------------+
              |
              v
           Internet
```

Worker nodes are placed in private subnets.

---

## 3.4 Complete Architecture

```text
                                INTERNET
                                    |
                                    v
                           AWS Load Balancer
                                    |
                                    v
                          Frontend LoadBalancer
                                    |
                                    v
                              Frontend Pods
                                    |
              +---------------------+---------------------+
              |           |          |          |         |
              v           v          v          v         v
            Cart       Checkout    Product    Currency  Recommendation
              |           |          |          |         |
              +-----------+----------+----------+---------+
                                    |
                                  Redis


Developer
    |
    v
GitHub
    |
    v
GitHub Actions
    |
    +--> Detect Changed Services
    |
    +--> Build Docker Image
    |
    +--> Trivy Security Scan
    |
    +--> Push to ECR
    |
    +--> Update Kubernetes Image Tag
    |
    v
Git
    |
    v
Argo CD
    |
    v
EKS
    |
    +------------------+
    |                  |
    v                  v
Application        Monitoring
Pods                   |
                       +---- Prometheus
                       |
                       +---- Grafana
                       |
                       +---- Metrics Server
                                      |
                                      v
                                     HPA
```

---

# 4. Technology Stack

| Category | Technology |
|---|---|
| Cloud | AWS |
| AWS Region | ap-south-1 |
| Infrastructure as Code | Terraform |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Kubernetes | Amazon EKS |
| CI/CD | GitHub Actions |
| AWS Authentication | GitHub OIDC |
| Security Scanner | Trivy |
| GitOps | Argo CD |
| Kubernetes Configuration | Kustomize |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Metrics | Metrics Server |
| Autoscaling | Kubernetes HPA |
| Application | Online Boutique |
| Cache | Redis |

---

# 5. Repository Structure

```text
production-grade-gitops-microservices/
│
├── .github/
│   └── workflows/
│       └── microservices-ci.yml
│
├── argocd/
│   └── application.yaml
│
├── docker/
│
├── docs/
│
├── helm/
│
├── kubernetes/
│   ├── adservice.yaml
│   ├── cartservice.yaml
│   ├── checkoutservice.yaml
│   ├── currencyservice.yaml
│   ├── emailservice.yaml
│   ├── frontend.yaml
│   ├── frontend-hpa.yaml
│   ├── loadgenerator.yaml
│   ├── paymentservice.yaml
│   ├── productcatalogservice.yaml
│   ├── recommendationservice.yaml
│   ├── shippingservice.yaml
│   └── kustomization.yaml
│
├── observability/
│
├── src/
│   ├── adservice/
│   ├── cartservice/
│   ├── checkoutservice/
│   ├── currencyservice/
│   ├── emailservice/
│   ├── frontend/
│   ├── loadgenerator/
│   ├── paymentservice/
│   ├── productcatalogservice/
│   ├── recommendationservice/
│   ├── shippingservice/
│   └── shoppingassistantservice/
│
├── terraform/
│   ├── versions.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── ecr.tf
│   ├── github-oidc.tf
│   ├── output.tf
│   └── terraform.tfvars.example
│
├── .gitignore
├── README.md
└── ...
```

---

# 6. Microservices

The source repository contains 12 services.

```text
adservice
cartservice
checkoutservice
currencyservice
emailservice
frontend
loadgenerator
paymentservice
productcatalogservice
recommendationservice
shippingservice
shoppingassistantservice
```

## Services deployed to EKS

The initial deployment uses 11 services:

```text
adservice
cartservice
checkoutservice
currencyservice
emailservice
frontend
loadgenerator
paymentservice
productcatalogservice
recommendationservice
shippingservice
```

Redis is deployed separately as a supporting dependency.

---

## Shopping Assistant Service

`shoppingassistantservice` exists in the source repository but is not part of the initial EKS deployment.

It depends on external Google Cloud services.

Required configuration includes:

```text
PROJECT_ID
REGION
ALLOYDB_DATABASE_NAME
ALLOYDB_TABLE_NAME
ALLOYDB_CLUSTER_NAME
ALLOYDB_INSTANCE_NAME
ALLOYDB_SECRET_NAME
```

It can be added later as an advanced cross-cloud component.

---

# 7. AWS Infrastructure

Terraform provisions the AWS foundation.

## Resources

Terraform creates:

- VPC
- Internet Gateway
- Public Subnets
- Private Subnets
- Route Tables
- NAT Gateway
- Elastic IP
- EKS Cluster
- EKS Managed Node Group
- IAM Roles
- ECR Repositories
- GitHub OIDC Provider
- GitHub Actions IAM Role

---

## Default Configuration

AWS Region:

```text
ap-south-1
```

Project Name:

```text
production-grade-gitops
```

EKS Cluster:

```text
production-grade-gitops-eks
```

VPC CIDR:

```text
10.0.0.0/16
```

Public Subnets:

```text
10.0.1.0/24
10.0.2.0/24
```

Private Subnets:

```text
10.0.11.0/24
10.0.12.0/24
```

Worker Instance:

```text
t3.medium
```

Initial Worker Nodes:

```text
2
```

Minimum:

```text
2
```

Maximum:

```text
3
```

---

# 8. Terraform

Terraform manages the AWS infrastructure.

Terraform is intentionally kept simple with files at the same level rather than using complex modules.

---

## Terraform Files

### `versions.tf`

Defines Terraform and AWS provider requirements.

### `provider.tf`

Configures the AWS provider.

### `variables.tf`

Contains configurable values such as:

- AWS region
- Project name
- VPC CIDR
- Subnet CIDRs
- EKS cluster name
- Worker instance types
- Node scaling values
- Microservice names

### `main.tf`

Creates networking:

- VPC
- Public subnets
- Private subnets
- Internet Gateway
- Route tables
- NAT Gateway
- Elastic IP

### `iam.tf`

Creates:

- EKS cluster IAM role
- EKS worker IAM role
- Required AWS policies

### `eks.tf`

Creates:

- EKS cluster
- Managed node group

### `ecr.tf`

Creates one ECR repository for each service.

### `github-oidc.tf`

Creates:

- GitHub OIDC provider
- GitHub Actions IAM role
- ECR permissions

### `output.tf`

Provides useful infrastructure outputs.

---

# 9. Amazon ECR

Amazon ECR stores the Docker images.

Repository naming:

```text
production-grade-gitops/<service>
```

Full repository format:

```text
<ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/production-grade-gitops/<service>
```

ECR repositories are created automatically by Terraform.

ECR scanning on push is enabled.

---

## Login to ECR

```bash
aws ecr get-login-password \
  --region ap-south-1 \
  | docker login \
  --username AWS \
  --password-stdin \
  <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
```

---

# 10. Docker

Each service has its own Dockerfile.

Normal structure:

```text
src/<service>/Dockerfile
```

---

## Cartservice Special Case

`cartservice` uses a different Docker build context.

Dockerfile:

```text
src/cartservice/src/Dockerfile
```

Build context:

```text
src/cartservice/src
```

This must be remembered when manually building the image.

---

## Image Tags

The CI pipeline uses:

```text
<service>:<git-commit-sha>
```

and:

```text
<service>:latest
```

The Git SHA is preferred for deployments because it provides traceability.

Example:

```text
frontend:<git-sha>
```

This allows us to determine which Git commit produced a running image.

---

# 11. Kubernetes

Kubernetes manifests are stored in:

```text
kubernetes/
```

Main Kustomize file:

```text
kubernetes/kustomization.yaml
```

---

## Application Components

The deployment contains:

```text
adservice
cartservice
checkoutservice
currencyservice
emailservice
frontend
loadgenerator
paymentservice
productcatalogservice
recommendationservice
shippingservice
redis
```

The frontend HPA is also managed through the Kubernetes configuration.

---

## Validate Kubernetes Manifests

```bash
kubectl kustomize kubernetes
```

---

## Manual Deployment

```bash
kubectl apply -k kubernetes
```

Normally, after GitOps is configured, Argo CD manages these resources.

---

## Check Pods

```bash
kubectl get pods
```

---

## Check Services

```bash
kubectl get svc
```

---

# 12. Kustomize

Kustomize manages the Kubernetes manifests without requiring separate YAML files for every environment.

The main file is:

```text
kubernetes/kustomization.yaml
```

It also contains image tag configuration.

Example:

```yaml
images:
  - name: frontend
    newTag: <git-sha>
```

GitHub Actions updates these tags automatically.

---

# 13. Argo CD and GitOps

Argo CD is responsible for synchronizing Git state with Kubernetes.

Application manifest:

```text
argocd/application.yaml
```

Repository:

```text
https://github.com/atique5md/production-grade-gitops-microservices.git
```

Source path:

```text
kubernetes
```

Destination:

```text
default namespace
```

---

## GitOps Flow

```text
GitHub
   |
   v
kubernetes/kustomization.yaml
   |
   v
Argo CD
   |
   v
Kubernetes
```

---

## Automated Sync

The Argo CD Application uses:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

### Automated Sync

Git changes are automatically deployed.

### Prune

Resources removed from Git can be removed from Kubernetes.

### Self-Heal

Manual changes made to Kubernetes can be reverted to match Git.

---

## Install Argo CD

Install into the `argocd` namespace.

If the standard installation produces a CRD annotation-size error, use:

```bash
kubectl apply \
  -n argocd \
  --server-side \
  --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Check:

```bash
kubectl get pods -n argocd
```

---

## Create Argo CD Application

```bash
kubectl apply -f argocd/application.yaml
```

Check:

```bash
kubectl get application production-grade-gitops -n argocd
```

Expected:

```text
Synced
Healthy
```

---

## Argo CD Self-Healing Test

The project tested self-healing.

For example:

```bash
kubectl scale deployment frontend --replicas=1
```

If Git defines:

```text
replicas: 2
```

Argo CD detects the difference and restores the deployment to 2 replicas.

This demonstrates the GitOps principle:

```text
Git = Desired State
Kubernetes = Actual State
Argo CD = Reconciliation
```

---

# 14. GitHub Actions CI/CD

Workflow:

```text
.github/workflows/microservices-ci.yml
```

The pipeline is designed to build only changed microservices.

---

## CI/CD Flow

```text
Developer Push
      |
      v
Detect Changed Services
      |
      v
Build Docker Image
      |
      v
Trivy Security Scan
      |
      +------ FAIL ------> Stop
      |
      v
Push Image to ECR
      |
      v
Update Kubernetes Image Tag
      |
      v
Commit GitOps Change
      |
      v
Push to GitHub
      |
      v
Argo CD
      |
      v
Amazon EKS
```

---

## Changed Service Detection

The workflow compares the previous Git commit with the current commit.

This means:

```text
Change frontend
```

does not require rebuilding all services.

Only the changed service is processed.

---

## Matrix Builds

GitHub Actions uses a matrix to build multiple changed services.

For example:

```text
frontend
cartservice
paymentservice
```

can be built independently in the same workflow.

---

## GitOps Update

After successful image builds, the workflow updates:

```text
kubernetes/kustomization.yaml
```

with the new Git SHA.

The workflow then commits the change.

Example:

```text
gitops: update microservice image tags
```

---

## Important Workflow Design

The workflow triggers on:

```text
src/**
.github/workflows/microservices-ci.yml
```

The Kubernetes manifest update is intentionally not included as a workflow trigger.

Why?

Because the pipeline itself updates:

```text
kubernetes/kustomization.yaml
```

If that file triggered the same workflow, it could create an unnecessary CI loop.

---

# 15. GitHub OIDC

GitHub Actions authenticates with AWS using OpenID Connect.

No long-lived AWS access keys are stored in GitHub Actions.

---

## Architecture

```text
GitHub Actions
      |
      v
GitHub OIDC
      |
      v
AWS STS
      |
      v
IAM Role
      |
      v
Amazon ECR
```

---

## Advantages

- No permanent AWS credentials in GitHub
- Short-lived credentials
- Repository-based trust
- Branch-based trust
- Better security
- Easier credential management

The IAM trust policy is restricted to the intended repository and main branch.

---

# 16. Trivy Security

Trivy is used as a security gate in CI/CD.

---

## Pipeline

```text
Docker Build
     |
     v
Trivy Scan
     |
     +---- HIGH/CRITICAL ----> FAIL
     |
     v
ECR Push
```

The scan checks:

```text
HIGH
CRITICAL
```

Unfixed vulnerabilities are ignored.

The pipeline uses:

```text
exit-code: 1
```

for security failures.

Therefore:

> A vulnerable image does not proceed to the ECR push stage.

---

## Security Improvement Example

During the project, the frontend image initially contained many HIGH and CRITICAL vulnerabilities.

The problem was addressed by:

- Updating Go dependencies
- Updating OpenTelemetry dependencies
- Updating gRPC
- Updating Go crypto/network/text packages
- Updating the Go build image

The Go build environment was updated to:

```text
Go 1.25.14
```

After rebuilding, the image reported:

```text
HIGH: 0
CRITICAL: 0
```

This demonstrates why dependency management and container security scanning are both important.

---

# 17. Observability

Monitoring was implemented using:

- Prometheus
- Grafana
- Alertmanager
- kube-state-metrics
- node-exporter

The stack was installed using:

```text
prometheus-community/kube-prometheus-stack
```

Namespace:

```text
monitoring
```

---

## Add Helm Repository

```bash
helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts
```

Update:

```bash
helm repo update
```

Install:

```bash
helm install monitoring \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

---

## Verify

```bash
kubectl get pods -n monitoring
```

Expected components include:

```text
Prometheus
Grafana
Alertmanager
Prometheus Operator
kube-state-metrics
node-exporter
```

---

# 18. Prometheus

Prometheus collects metrics from Kubernetes and nodes.

Prometheus service:

```text
monitoring-kube-prometheus-prometheus
```

---

## Port Forward

```bash
kubectl port-forward \
  -n monitoring \
  svc/monitoring-kube-prometheus-prometheus \
  9090:9090
```

---

## Basic Query

```promql
up
```

This verifies that Prometheus targets are reporting.

---

## Node CPU

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

---

## Node Memory

```promql
100 * (
  1 -
  avg by (instance) (
    node_memory_MemAvailable_bytes
    /
    node_memory_MemTotal_bytes
  )
)
```

---

## Pod CPU

```promql
sum by (namespace, pod) (
  rate(container_cpu_usage_seconds_total{
    container!="",
    container!="POD",
    image!=""
  }[5m])
)
```

---

## Default Namespace Pod CPU

```promql
sum by (pod) (
  rate(container_cpu_usage_seconds_total{
    namespace="default",
    container!="",
    container!="POD",
    image!=""
  }[5m])
)
```

---

## Pod Memory

```promql
sum by (namespace, pod) (
  container_memory_working_set_bytes{
    container!="",
    container!="POD",
    image!=""
  }
)
```

---

## Pod Status

```promql
sum by (phase) (
  kube_pod_status_phase{
    namespace="default"
  }
)
```

---

# 19. Grafana

Grafana is used to visualize Prometheus metrics.

Service:

```text
monitoring-grafana
```

---

## Port Forward

```bash
kubectl port-forward \
  -n monitoring \
  svc/monitoring-grafana \
  3000:80 \
  --address 0.0.0.0
```

---

## Custom Dashboard

Dashboard name:

```text
EKS Microservices Overview
```

Panels:

1. EKS Node CPU Usage
2. EKS Node Memory Usage
3. Pod CPU Usage
4. Pod Memory Usage
5. Pod Status

---

# 20. Metrics Server

Metrics Server provides Kubernetes resource metrics.

It is required for:

```bash
kubectl top nodes
kubectl top pods
```

and is also required for CPU/memory-based HPA.

---

## Install

```bash
kubectl apply -f \
  https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify:

```bash
kubectl get pods -n kube-system | grep metrics
```

Then:

```bash
kubectl top nodes
```

---

# 21. Horizontal Pod Autoscaler

The frontend HPA is stored in Git:

```text
kubernetes/frontend-hpa.yaml
```

---

## Configuration

```text
Minimum replicas: 2
Maximum replicas: 5
CPU target: 70%
Scale-down stabilization: 60 seconds
```

The HPA uses:

```text
autoscaling/v2
```

---

## Check HPA

```bash
kubectl get hpa frontend
```

Example:

```text
TARGETS       MINPODS   MAXPODS   REPLICAS
cpu: 6%/70%   2         5         2
```

---

## GitOps Ownership

The HPA is managed by Argo CD.

Verify:

```bash
kubectl get hpa frontend \
  -o jsonpath='{.metadata.annotations.argocd\.argoproj\.io/tracking-id}'; echo
```

Expected format:

```text
production-grade-gitops:autoscaling/HorizontalPodAutoscaler:default/frontend
```

---

## HPA Testing Note

The HPA was configured successfully and Kubernetes metrics were working.

A full high-load 2-to-5 replica scaling test was not completed.

During aggressive load-generator testing, the two-worker cluster reached its Pod scheduling capacity.

Therefore:

> HPA configuration was verified, but a complete maximum-scale stress test should not be claimed.

---

# 22. Important Problems and Solutions

This section records real issues encountered during the project.

---

## Problem 1 — Argo CD CRD Annotation Error

### Error

Client-side installation produced a CRD annotation-size error.

### Solution

Use server-side apply:

```bash
kubectl apply \
  -n argocd \
  --server-side \
  --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Lesson

Large Kubernetes CRDs can exceed client-side annotation limits.

---

# Problem 2 — GitHub OIDC Authentication Failed

The initial GitHub OIDC trust policy used an incorrect repository subject.

The trust policy was corrected to match the GitHub OIDC `sub` claim and restrict access to the intended repository and branch.

### Lesson

OIDC trust policies must exactly match the identity claims provided by GitHub.

---

# Problem 3 — ECR Push Failed

GitHub Actions initially failed because the IAM role did not have:

```text
ecr:BatchGetImage
```

After adding the required permission, ECR push succeeded.

### Lesson

IAM permissions must match the AWS API operations actually used by the CI pipeline.

---

# Problem 4 — Trivy Found Vulnerabilities

The first frontend image contained many HIGH and CRITICAL vulnerabilities.

The main causes were:

- Outdated Go dependencies
- Outdated Go standard library

### Solution

Dependencies and the Go build image were upgraded.

Final scan:

```text
HIGH: 0
CRITICAL: 0
```

### Lesson

Container security requires both:

- Secure dependencies
- Secure base/build images

---

# Problem 5 — Trivy Did Not Initially Block CI

The first security scan used:

```text
exit-code: 0
```

This meant vulnerabilities were reported but did not fail the pipeline.

It was changed to:

```text
exit-code: 1
```

Now security findings block the pipeline.

### Lesson

A scanner becomes a real security gate only when unacceptable findings cause CI failure.

---

# Problem 6 — Metrics API Was Not Available

Initially:

```bash
kubectl top nodes
```

returned:

```text
Metrics API not available
```

Metrics Server was installed.

After it became healthy:

```bash
kubectl top nodes
```

worked successfully.

### Lesson

HPA and resource monitoring require a working metrics pipeline.

---

# Problem 7 — Pods Could Not Be Scheduled

During aggressive load testing:

```text
0/2 nodes are available: 2 Too many pods.
```

The worker nodes had reached their observed Pod capacity.

### Lesson

Kubernetes scheduling is not based only on CPU and memory.

A node can have free CPU but still reject a Pod because another scheduling limit has been reached.

---

# Problem 8 — Git Branches Diverged

GitHub Actions creates GitOps commits automatically.

Therefore, local Git can become behind the remote repository.

Safe recovery:

```bash
git fetch origin
git log --oneline --decorate --graph --all -8
git pull --rebase origin main
git push origin main
```

Do not force-push normal GitOps history.

---

# 23. Important Lessons Learned

## 1. Git is the source of desired state

GitOps works like:

```text
Git
 |
 v
Argo CD
 |
 v
Kubernetes
```

Git defines what should exist.

Argo CD continuously reconciles Kubernetes with Git.

---

## 2. Self-healing protects desired state

Manual Kubernetes changes can be reverted automatically by Argo CD.

---

## 3. SHA image tags provide traceability

Instead of only:

```text
frontend:latest
```

the deployment uses:

```text
frontend:<git-sha>
```

This tells us exactly which Git commit produced the deployed image.

---

## 4. Security scanning should happen before deployment

Correct:

```text
Build
 |
 v
Scan
 |
 v
Push
 |
 v
Deploy
```

Not:

```text
Build
 |
 v
Push
 |
 v
Deploy
 |
 v
Discover vulnerabilities
```

---

## 5. Kubernetes Pod capacity matters

A worker node has more constraints than:

```text
CPU
Memory
```

Pod capacity is also important.

---

## 6. Observability is essential

Prometheus and Grafana help answer:

- Is the application healthy?
- Which node is using CPU?
- Which Pod is consuming resources?
- Is memory usage increasing?
- Are Pods running?
- Is autoscaling working?

---

## 7. Ephemeral Redis is not production persistence

The current Redis manifest uses:

```text
emptyDir
```

Therefore Redis data can disappear when the Pod is recreated.

For production, consider Amazon ElastiCache or a properly designed persistent Redis architecture.

---

# 24. Complete Rebuild Guide

This section should be used if the AWS environment has been completely destroyed.

---

# Phase 1 — Clone Repository

```bash
git clone https://github.com/atique5md/production-grade-gitops-microservices.git
```

Then:

```bash
cd production-grade-gitops-microservices
```

---

# Phase 2 — Configure AWS

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

Check region:

```bash
aws configure get region
```

Expected:

```text
ap-south-1
```

---

# Phase 3 — Create AWS Infrastructure

Go to Terraform:

```bash
cd terraform
```

Create variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Review:

```text
terraform.tfvars
```

Then:

```bash
terraform init
```

Format:

```bash
terraform fmt -recursive
```

Validate:

```bash
terraform validate
```

Create plan:

```bash
terraform plan
```

If the plan is correct:

```bash
terraform apply
```

---

# Phase 4 — Configure kubectl

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name production-grade-gitops-eks
```

Verify:

```bash
kubectl get nodes
```

Expected:

```text
Ready
```

---

# Phase 5 — Verify ECR

```bash
aws ecr describe-repositories \
  --region ap-south-1
```

---

# Phase 6 — Install Argo CD

```bash
kubectl apply \
  -n argocd \
  --server-side \
  --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Verify:

```bash
kubectl get pods -n argocd
```

---

# Phase 7 — Create Argo CD Application

```bash
kubectl apply -f argocd/application.yaml
```

Verify:

```bash
kubectl get application production-grade-gitops -n argocd
```

Expected:

```text
Synced
Healthy
```

---

# Phase 8 — Build and Push Images

Normally GitHub Actions performs the build and push.

For manual testing:

```bash
aws ecr get-login-password \
  --region ap-south-1 \
  | docker login \
  --username AWS \
  --password-stdin \
  <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
```

Remember:

```text
cartservice
```

uses:

```text
src/cartservice/src
```

as its Docker build context.

---

# Phase 9 — Verify Application

```bash
kubectl get pods
```

Then:

```bash
kubectl get svc
```

Frontend:

```bash
kubectl get svc frontend-external
```

The AWS Load Balancer hostname is created dynamically.

---

# Phase 10 — Install Monitoring

Add repository:

```bash
helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts
```

Update:

```bash
helm repo update
```

Install:

```bash
helm install monitoring \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

Verify:

```bash
kubectl get pods -n monitoring
```

---

# Phase 11 — Install Metrics Server

```bash
kubectl apply -f \
  https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify:

```bash
kubectl get pods -n kube-system | grep metrics
```

Then:

```bash
kubectl top nodes
```

---

# Phase 12 — Verify HPA

```bash
kubectl get hpa frontend
```

---

# Phase 13 — Verify GitHub Actions

Check GitHub Actions and confirm:

- Changed service detection works
- Docker build succeeds
- Trivy scan passes
- Image is pushed to ECR
- Kubernetes image tag is updated
- GitOps commit is created
- Argo CD detects the Git change
- Application becomes Healthy

---

# Phase 14 — Verify Grafana

Port-forward:

```bash
kubectl port-forward \
  -n monitoring \
  svc/monitoring-grafana \
  3000:80 \
  --address 0.0.0.0
```

Open the Grafana interface through the SSH tunnel.

Verify:

```text
EKS Microservices Overview
```

dashboard.

---

# 25. Verification Checklist

## AWS

```bash
aws sts get-caller-identity
```

---

## EKS

```bash
kubectl get nodes
```

All workers should be:

```text
Ready
```

---

## Application

```bash
kubectl get pods
```

Expected application Pods should be:

```text
Running
```

---

## Services

```bash
kubectl get svc
```

Frontend should be:

```text
LoadBalancer
```

---

## Argo CD

```bash
kubectl get application production-grade-gitops -n argocd
```

Expected:

```text
Synced
Healthy
```

---

## Monitoring

```bash
kubectl get pods -n monitoring
```

---

## Metrics

```bash
kubectl top nodes
```

---

## HPA

```bash
kubectl get hpa frontend
```

---

## GitOps Tracking

```bash
kubectl get hpa frontend \
  -o jsonpath='{.metadata.annotations.argocd\.argoproj\.io/tracking-id}'; echo
```

---

## Grafana

Verify:

```text
EKS Microservices Overview
```

---

# 26. Useful Commands

## Kubernetes

```bash
kubectl get nodes
```

```bash
kubectl get pods
```

```bash
kubectl get pods -A
```

```bash
kubectl get svc
```

```bash
kubectl get deployments
```

```bash
kubectl get hpa
```

---

## Describe Resource

```bash
kubectl describe pod <pod-name>
```

```bash
kubectl describe deployment <deployment-name>
```

---

## Logs

```bash
kubectl logs <pod-name>
```

For previous container:

```bash
kubectl logs <pod-name> --previous
```

---

## Events

```bash
kubectl get events --sort-by=.lastTimestamp
```

---

## Kustomize

```bash
kubectl kustomize kubernetes
```

---

## Docker

```bash
docker ps
```

```bash
docker images
```

```bash
docker build .
```

---

## ECR

```bash
aws ecr describe-repositories --region ap-south-1
```

---

## Terraform

```bash
terraform init
```

```bash
terraform fmt -recursive
```

```bash
terraform validate
```

```bash
terraform plan
```

```bash
terraform apply
```

```bash
terraform output
```

---

## Git

```bash
git status
```

```bash
git log --oneline --decorate --graph --all -10
```

```bash
git fetch origin
```

```bash
git pull --rebase origin main
```

```bash
git push origin main
```

---

# 27. Cleanup and Destroy

When the AWS environment is no longer required, destroy it to avoid unnecessary AWS costs.

Go to Terraform:

```bash
cd terraform
```

---

## First Review Destroy Plan

```bash
terraform plan -destroy
```

Always inspect the resources that Terraform intends to remove.

---

## Destroy

If everything is correct:

```bash
terraform destroy
```

Confirm when prompted.

---

## Resources Expected to Be Removed

Terraform-managed resources include:

- EKS cluster
- Worker nodes
- VPC
- Public subnets
- Private subnets
- NAT Gateway
- Elastic IP
- Route tables
- ECR repositories
- IAM roles
- GitHub OIDC resources

Resources installed inside EKS, such as:

- Argo CD
- Prometheus
- Grafana
- Metrics Server
- Application Pods

will disappear when the EKS cluster is destroyed.

The GitHub repository remains untouched.

---

# 28. Security Guidelines

Never commit:

```text
AWS Access Keys
AWS Secret Keys
SSH Private Keys
GitHub Personal Access Tokens
Passwords
API Keys
Terraform secrets
Sensitive .env files
```

Use:

```text
GitHub OIDC
IAM least privilege
Kubernetes Secrets
AWS Secrets Manager
External Secrets
Immutable image tags
Trivy scanning
```

---

## GitHub Actions Security

Do not add long-lived:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

as GitHub secrets for this project.

The project uses:

```text
GitHub OIDC
```

instead.

---

# 29. Production Improvements

The current project is production-oriented but intentionally kept manageable for learning.

Possible future improvements:

---

## Networking

- AWS Load Balancer Controller
- Kubernetes Ingress
- HTTPS
- ACM certificates
- AWS WAF

---

## Security

- NetworkPolicies
- Pod Security Standards
- AWS Secrets Manager
- External Secrets Operator
- More granular IAM
- More granular Kubernetes RBAC

---

## Reliability

- PodDisruptionBudgets
- Pod anti-affinity
- Topology spread constraints
- Multi-AZ worker strategy
- Better Redis architecture

---

## Redis

Replace ephemeral Redis with:

```text
Amazon ElastiCache
```

or another persistent production Redis solution.

---

## Observability

Future improvements:

- Loki
- OpenTelemetry
- Distributed tracing
- Application metrics
- Alerting
- CloudWatch integration

---

## Environments

Create separate:

```text
development
staging
production
```

environments.

---

## Advanced Cross-Cloud Integration

Integrate:

```text
shoppingassistantservice
```

with its Google Cloud dependencies.

---

# 30. Interview Explanation

## 30.1 Two-Minute Explanation

> I built a production-oriented GitOps microservices platform on AWS EKS.
>
> I used Terraform to provision the VPC, public and private subnets, NAT Gateway, EKS cluster, managed worker nodes, ECR repositories, IAM roles, and GitHub OIDC.
>
> For CI/CD, GitHub Actions detects which microservices have changed, builds Docker images, scans them using Trivy, and pushes the secure images to Amazon ECR.
>
> After the image is pushed, the pipeline updates the Kubernetes image tag using the Git commit SHA. Argo CD watches the Git repository and automatically synchronizes those changes to EKS.
>
> I also tested Argo CD self-healing by manually changing the frontend replica count and verifying that Argo CD restored the desired state defined in Git.
>
> For observability, I deployed Prometheus and Grafana and created a dashboard showing node CPU, node memory, Pod CPU, Pod memory, and Pod status.
>
> I also installed Metrics Server and configured a CPU-based Horizontal Pod Autoscaler for the frontend.
>
> So the overall workflow is Infrastructure as Code, containerization, CI/CD, security scanning, GitOps, Kubernetes, observability, and autoscaling.

---

## 30.2 Explain the Architecture

If asked:

### "Explain your architecture."

Answer:

> The application runs on Amazon EKS. The worker nodes are deployed in private subnets inside a custom VPC. The frontend is exposed through an AWS LoadBalancer Service.
>
> The frontend communicates with the backend microservices using Kubernetes services, and Redis is used as the cart storage backend.
>
> Terraform manages the AWS infrastructure.
>
> GitHub Actions handles CI by detecting changed services, building Docker images, scanning them with Trivy, and pushing them to ECR.
>
> Argo CD provides GitOps-based continuous deployment by watching the Kubernetes manifests stored in Git.
>
> Prometheus collects metrics, Grafana visualizes them, Metrics Server provides resource metrics, and HPA uses those metrics for autoscaling.

---

## 30.3 Explain GitOps

> Git is the source of truth. When a developer pushes code, GitHub Actions builds and scans the image and updates the Kubernetes image tag in Git. Argo CD detects the Git change and synchronizes Kubernetes with the desired state.
>
> If someone manually changes Kubernetes, Argo CD self-healing can revert the change back to the state defined in Git.

---

## 30.4 Explain CI/CD

```text
Developer
   |
   v
Git Push
   |
   v
GitHub Actions
   |
   +--> Detect Changed Services
   |
   +--> Docker Build
   |
   +--> Trivy Scan
   |
   +--> ECR Push
   |
   +--> Update Kubernetes Manifest
   |
   v
Git
   |
   v
Argo CD
   |
   v
EKS
```

---

## 30.5 Explain Trivy

> I integrated Trivy into the CI pipeline as a security gate. Docker images are scanned before they are pushed to ECR. HIGH and CRITICAL vulnerabilities cause the workflow to fail. This prevents known vulnerable images from progressing through the deployment pipeline.

---

## 30.6 Explain OIDC

> Instead of storing permanent AWS access keys in GitHub, I configured GitHub OIDC. GitHub provides an identity token, AWS verifies the token, and STS provides temporary credentials through an IAM role. The role is restricted to the intended repository and branch.

---

## 30.7 Explain HPA

> I configured an autoscaler for the frontend using the autoscaling/v2 API. It maintains a minimum of two replicas and can scale up to five based on CPU utilization, with a target of 70 percent.
>
> Metrics Server provides the resource metrics used by Kubernetes.

---

# 31. Project Status

## Completed

- [x] AWS VPC
- [x] Public subnets
- [x] Private subnets
- [x] Internet Gateway
- [x] NAT Gateway
- [x] Route tables
- [x] IAM
- [x] Amazon EKS
- [x] Managed worker nodes
- [x] Amazon ECR
- [x] Docker images
- [x] Kubernetes manifests
- [x] Kustomize
- [x] Argo CD
- [x] GitOps
- [x] Automated sync
- [x] Argo CD self-healing
- [x] GitHub Actions
- [x] Changed-service detection
- [x] GitHub OIDC
- [x] Trivy security scanning
- [x] Security gate
- [x] Prometheus
- [x] Grafana
- [x] Custom Grafana dashboard
- [x] Metrics Server
- [x] Horizontal Pod Autoscaler
- [x] GitOps-managed HPA
- [x] Kubernetes security contexts
- [x] Resource requests and limits
- [x] Health probes
- [x] Load generator

---

## Not Included in Initial Deployment

- [ ] Shopping Assistant cross-cloud integration
- [ ] Persistent production Redis
- [ ] Centralized logging
- [ ] Distributed tracing
- [ ] Production HTTPS
- [ ] AWS Load Balancer Controller / Ingress
- [ ] NetworkPolicies
- [ ] Multi-environment setup

These are future improvements and are not required for the current project.

---

# 🎯 Final Project Flow

```text
                         DEVELOPER
                             |
                             v
                          GITHUB
                             |
                             v
                    GITHUB ACTIONS
                             |
             +---------------+---------------+
             |               |               |
             v               v               v
        Detect Changes    Docker Build    Trivy Scan
                                             |
                                             v
                                      Security Gate
                                             |
                                             v
                                          ECR
                                             |
                                             v
                                    GitOps Manifest
                                             |
                                             v
                                         ARGO CD
                                             |
                                             v
                                      AMAZON EKS
                                             |
                        +--------------------+--------------------+
                        |                    |                   |
                        v                    v                   v
                   Microservices          Redis                HPA
                        |
                        v
                    Monitoring
                        |
              +---------+---------+
              |                   |
              v                   v
          Prometheus           Grafana
```

---

# 🧠 Core DevOps Concepts Demonstrated

```text
Infrastructure as Code
          +
Containerization
          +
CI/CD
          +
Security Scanning
          +
Cloud Authentication
          +
GitOps
          +
Kubernetes
          +
Observability
          +
Autoscaling
          =
Complete DevOps Workflow
```

---

# ⭐ Key Takeaway

This project demonstrates how application code moves from a developer's workstation all the way to a monitored and autoscaled Kubernetes environment:

```text
Code
 ↓
GitHub
 ↓
GitHub Actions
 ↓
Docker
 ↓
Trivy
 ↓
Amazon ECR
 ↓
GitOps
 ↓
Argo CD
 ↓
Amazon EKS
 ↓
Prometheus
 ↓
Grafana
 ↓
Metrics Server
 ↓
HPA
```

The repository contains the configuration required to rebuild the environment, while this README documents the process, architecture, troubleshooting lessons, and operational commands.

---

# 👨‍💻 Author

**Md Atique**

GitHub:

https://github.com/atique5md

Repository:

https://github.com/atique5md/production-grade-gitops-microservices

---

# 📌 Before Destroying AWS

Before destroying the AWS environment:

1. Push the latest README to GitHub.
2. Verify the GitHub repository is accessible.
3. Take screenshots of:
   - Running application
   - EKS Pods
   - Argo CD
   - Grafana dashboard
   - HPA
   - Successful GitHub Actions pipeline
4. Run:

```bash
terraform plan -destroy
```

5. Review the plan.
6. Run:

```bash
terraform destroy
```

This allows the AWS environment to be recreated later without losing the project documentation.

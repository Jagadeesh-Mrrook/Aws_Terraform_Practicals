AWS + Terraform Practical Learning Plan

# Overview

This plan is designed to teach AWS and Terraform together in a structured, practical way. Each phase includes step-by-step console instructions, Terraform implementation, outputs, testing, and mini challenges.

---

## Phase 1: Core Compute + Networking (Day 1–3)

**Services:** VPC, Subnets, Security Groups, EC2, ALB, Auto Scaling Group
**Goal:** Deploy a basic web application environment.

### Sub-Phases:

1. **VPC**

   * Concept explanation
   * AWS console creation
   * Terraform creation & apply
   * Testing connectivity
   * Mini challenge (e.g., add a second CIDR block)

2. **Subnets**

   * Public and private subnets
   * Route tables & IGW
   * Terraform creation
   * Testing (ping, SSH if applicable)
   * Mini challenge (e.g., create additional subnet in a different AZ)

3. **Security Groups**

   * EC2 & ALB specific
   * Rules: SSH/HTTP/HTTPS
   * Terraform creation
   * Testing connectivity
   * Mini challenge (restrict SSH to a specific IP)

4. **EC2 Instances**

   * Launch using Launch Template
   * Terraform creation
   * Testing SSH & outputs (Public IP, private IP)
   * Mini challenge (deploy multiple EC2s)

5. **ALB**

   * Target groups & listeners
   * Attach EC2 instances
   * Terraform creation
   * Testing HTTP traffic via ALB DNS
   * Mini challenge (path-based routing)

6. **Auto Scaling Group**

   * Launch template
   * Terraform creation
   * Testing scaling up/down
   * Mini challenge (change scaling policies, min/max instances)

---

## Phase 2: Storage + Identity (Day 4)

**Services:** S3, IAM, KMS
**Goal:** Secure storage and access management.

* S3: Public/private buckets, versioning, Terraform creation, testing, mini challenge (cross-account access)
* IAM: Users, roles, policies, Terraform creation, testing, mini challenge (dynamic policy attachment)
* KMS: S3 bucket encryption, Terraform creation, testing, mini challenge (rotate keys, re-encrypt bucket)

---

## Phase 3: Monitoring + Logging (Day 5)

**Services:** CloudWatch, CloudTrail, SNS
**Goal:** Observability and alerts for infrastructure.

* CloudWatch alarms, CloudTrail logs, SNS topic creation
* Terraform deployment, testing, mini challenges (e.g., trigger SNS on CPU > 70%)

---

## Phase 4: Databases + Backup (Day 6)

**Services:** RDS, DynamoDB, Snapshots
**Goal:** Deploy managed databases securely with backups.

* RDS instance creation, DynamoDB table, Terraform deployment
* Testing connectivity & backups
* Mini challenge: Connect RDS to EC2 from Phase 1

---

## Phase 5: Serverless + Integration (Day 7)

**Services:** Lambda, API Gateway, SQS/SNS
**Goal:** Deploy serverless workflows and event-driven architecture.

* Lambda functions, API Gateway, SQS/SNS triggers
* Terraform deployment, testing
* Mini challenge: Trigger Lambda via multiple sources and verify CloudWatch logs

---

## Phase 6: Security + Management (Day 8)

**Services:** WAF, AWS Config, SSM
**Goal:** Apply security and management policies.

* Attach WAF to ALB, AWS Config rules, SSM command execution
* Terraform deployment, testing
* Mini challenge: Attach WAF to ALB from Phase 1 and test traffic rules

---

## Workflow During Each Day

1. Concept explanation (purpose, use cases, best practices)
2. AWS Console creation (step-by-step, mandatory fields highlighted)
3. Terraform implementation (resource block, mandatory/optional fields, plan/apply, testing outputs)
4. Mini challenges / variations (interview-style or extra tasks)
5. Notes generation (modular, AWS & Terraform, includes testing steps, pitfalls, best practices)

---

## Notes Structure

* Separate sections for AWS and Terraform for each resource
* Headings: Purpose, Mandatory Parameters, Optional Parameters, Pitfalls, Best Practices, Testing Steps, Mini Challenges
* Designed for future additions without breaking existing notes

---

## Optional Advanced Extensions

* VPC peering / Transit Gateway
* RDS multi-AZ / read replicas
* ALB advanced routing (host-based, weighted targets)
* Terraform modules for reusability
* CI/CD integration with Terraform

---
---
---


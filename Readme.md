## Realistic AWS + Terraform Daily Practical Plan (4 hours/day)

### Phase 1: Core Compute + Networking (Days 1–4)

**Goal:** Deploy a production-ready web application environment

| Day   | Services                                 | Notes                                                                                                                                                         |
| ----- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Day 1 | VPC                                      | Subnets, IGW, NAT Gateway, NACLs, Security Groups, secondary CIDRs, DNS, DHCP options, flow logs, VPC peering, VPC endpoints, tags, hybrid networking options |
| Day 2 | Subnets + Route Tables + Security Groups | Public/private subnets, route table associations, IGW/NAT routes, SG rules (SSH, HTTP, HTTPS), NACLs, connectivity testing                                    |
| Day 3 | EC2 Instances + Launch Templates + AMI   | Key pairs, security groups, IAM roles, monitoring, Elastic IPs, tagging, user data scripts, basic CloudWatch metrics                                          |
| Day 4 | ALB + Auto Scaling Group (ASG)           | Target groups, listeners, path-based routing, attach EC2 instances, scaling policies, min/max instances, monitoring via CloudWatch                            |

### Phase 2: Storage + Identity (Day 5)

**Goal:** Secure storage and access management

| Day   | Services                         | Notes                                                                                                                                                                                                                |
| ----- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Day 5 | S3 + IAM + KMS + Secrets Manager | S3 buckets (all storage classes, versioning, lifecycle, replication, cross-account), IAM users/roles/policies, KMS keys (rotation, re-encrypt), Secrets Manager for credentials, CloudTrail integration for tracking |

### Phase 3: Monitoring + Logging (Day 6)

**Goal:** Observability & user/API activity tracking

| Day   | Services                      | Notes                                                                                                                                                                        |
| ----- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Day 6 | CloudWatch + CloudTrail + SNS | CloudTrail (management & data events, S3 object-level, API activity, cross-account), CloudWatch metrics/alarms/logs, SNS notifications on alerts/events, integration testing |

### Phase 4: Databases + Backup (Day 7)

**Goal:** Managed databases securely with backups

| Day   | Services                   | Notes                                                                                                                                 |
| ----- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Day 7 | RDS + DynamoDB + Snapshots | RDS (multi-AZ, backups, monitoring), DynamoDB (tables, streams, TTL), EBS/RDS snapshots, connectivity from EC2, Terraform integration |

### Phase 5: Serverless + Integration (Days 8–9)

**Goal:** Serverless workflows & event-driven architecture

| Day   | Services                         | Notes                                                                                                                                                         |
| ----- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Day 8 | Lambda + API Gateway + SQS + SNS | Lambda functions (roles, env variables, versions, monitoring), API Gateway endpoints (HTTP/REST), SQS/SNS triggers, CloudWatch logs & alarms, mini-challenges |
| Day 9 | Optional Advanced Serverless     | Step Functions, multiple triggers, error handling, concurrency limits                                                                                         |

### Phase 6: Security + Management (Day 10)

**Goal:** Apply security & management policies

| Day    | Services                            | Notes                                                                                                                                                                        |
| ------ | ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Day 10 | WAF + AWS Config + SSM + AWS Shield | Attach WAF to ALB, CloudWatch monitoring of rules, AWS Config rules & drift detection, SSM commands & patching, AWS Shield for DDoS protection, testing traffic restrictions |

### Summary

* Phase 1: 4 days
* Phase 2: 1 day
* Phase 3: 1 day
* Phase 4: 1 day
* Phase 5: 2 days
* Phase 6: 1 day
  **Total:** 10 days (4 hours/day)

**Workflow Note:** You will provide the daily service/concept list at the start of the chat. Each day will follow the zero-missed-concepts practical workflow, including AWS console creation, Terraform implementation, testing, mini-challenges, and modular notes generation.

---
---
---

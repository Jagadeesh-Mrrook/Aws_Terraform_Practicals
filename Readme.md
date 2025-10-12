# AWS + Terraform Interview-Ready Service List (Updated)

This is a complete, service-wise list of AWS services with interview-focused points and Terraform guidance, including tagging best practices, high availability considerations, Terraform outputs, and interview verification points.

---

## 1️⃣ VPC & Networking

* Core Concepts: VPC, CIDR, public/private subnets
* Internet Gateway (IGW)
* NAT Gateway
* Route Tables
* Security Groups vs NACL
* Flow Logs
* Tagging: Use Name/Environment tags
* High Availability: Consider multiple AZs for subnets
* Terraform: Mandatory fields, linking EC2/subnets/Security Groups, outputs for VPC ID
* Interview: How EC2 attaches to VPC, common mistakes, difference between SG vs NACL, IGW vs NAT
* Verification: Check EC2 launch, ping test, flow logs enabled

---

## 2️⃣ Subnets

* Public vs Private, CIDR segmentation, AZ distribution
* Terraform: `aws_subnet`, mapping to VPC, outputs for subnet IDs
* Tagging: Name/Environment
* Interview: Route table associations, IGW vs NAT routing, subnet AZs for HA
* Verification: EC2 can launch in subnet, public subnet has internet access

---

## 3️⃣ Internet Gateway (IGW)

* Enable Internet access for public subnets
* Terraform: `aws_internet_gateway`, outputs for ID
* Tagging: Name/Environment
* Interview: Difference between IGW and NAT Gateway
* Verification: EC2 in public subnet can access internet

---

## 4️⃣ NAT Gateway

* Enable Internet access for private subnets
* Terraform: `aws_nat_gateway`, Elastic IP attachment, outputs for ID
* Tagging: Name/Environment
* Interview: Why NAT is needed, common misconfigurations
* Verification: EC2 in private subnet can access internet via NAT

---

## 5️⃣ Route Tables

* Routing traffic from subnets to IGW / NAT / other subnets
* Terraform: `aws_route_table`, `aws_route_table_association`, outputs
* Tagging: Name/Environment
* Interview: Linking multiple subnets, default routes, multi-AZ considerations
* Verification: Check routing with ping or traceroute

---

## 6️⃣ Security Groups

* Stateful firewall for EC2
* Terraform: `aws_security_group`, mandatory rules, outputs
* Tagging: Name/Environment
* Interview: Difference with NACL, common mistakes, security best practices
* Verification: Test connectivity allowed/blocked as per rules

---

## 7️⃣ Network ACLs

* Stateless firewall, subnet-level protection
* Terraform: `aws_network_acl`, `aws_network_acl_rule`, outputs
* Tagging: Name/Environment
* Interview: NACL vs Security Group, rule ordering
* Verification: Test blocked/allowed traffic on subnet

---

## 8️⃣ EC2 Instances

* Instance types, AMI, key pairs
* Terraform: `aws_instance`, linking to subnet + SG, outputs for instance ID/public IP
* Tagging: Name/Environment
* Interview: Attach EC2 to VPC/subnet, EBS attachments, multi-AZ placement for HA
* Verification: SSH into instance, test connectivity

---

## 9️⃣ EBS Volumes & Snapshots

* Volume types, attach/detach, snapshots
* Terraform: `aws_ebs_volume`, `aws_volume_attachment`, `aws_ebs_snapshot`, outputs
* Tagging: Name/Environment
* Interview: Restore from snapshot, live attachment, volume type considerations
* Verification: Mount volume, create snapshot, restore and attach

---

## 10️⃣ S3

* Buckets, versioning, lifecycle rules, storage classes, encryption
* Terraform: `aws_s3_bucket`, `aws_s3_bucket_policy`, outputs for bucket name
* Tagging: Name/Environment
* Interview: Bucket policies vs IAM roles, public access settings, lifecycle management
* Verification: Upload/download file, test policy enforcement

---

## 11️⃣ Load Balancers (ALB/NLB)

* ALB vs NLB, target groups, listeners
* Terraform: `aws_lb`, `aws_lb_target_group`, `aws_lb_listener`, outputs
* Tagging: Name/Environment
* Interview: Health checks, cross-AZ setup, listener rules
* Verification: Access application via LB DNS, check health status

---

## 12️⃣ Auto Scaling

* Launch Template/Configuration, ASG, scaling policies
* Terraform: `aws_launch_template`, `aws_autoscaling_group`, outputs
* Tagging: Name/Environment
* Interview: Linking with VPC/subnets/Security Groups, scaling triggers, multi-AZ setup
* Verification: Trigger scale up/down, verify instance launch and termination

---

## 13️⃣ CloudWatch / Monitoring

* Metrics, alarms, logs
* Terraform: `aws_cloudwatch_metric_alarm`, `aws_cloudwatch_log_group`, outputs
* Tagging: Name/Environment
* Interview: Monitor EC2, ALB, ASG; link with SNS for alerts
* Verification: Generate test alarm, check CloudWatch logs

---

## 14️⃣ CloudTrail (with User Audit)

* Audit trail for API calls and IAM user activity
* Tracks IAM users, federated users, root account actions
* Terraform: `aws_cloudtrail`, `include_global_service_events`, `is_multi_region_trail`, outputs
* Tagging: Name/Environment
* Interview: Difference between resource vs user activity, integrate with S3/CloudWatch, detect suspicious activity, monitor IAM user actions
* Verification: Make API call, check CloudTrail logs, verify user activity

---

## 15️⃣ IAM

* Users, groups, roles, policies
* Terraform: `aws_iam_user`, `aws_iam_role`, `aws_iam_policy`, outputs
* Tagging: Name/Environment
* Interview: Least privilege, EC2 roles for S3 access, role assumption, policy testing
* Verification: Attach role/policy, test resource access

---

## 16️⃣ Extras / Optional

* KMS: Encryption keys
* Secrets Manager: Store credentials securely
* Lambda: Trigger from S3 / CloudWatch
* Terraform: `aws_kms_key`, `aws_secretsmanager_secret`, `aws_lambda_function`, outputs
* Tagging: Name/Environment
* Verification: Encrypt/decrypt data, retrieve secret, invoke Lambda

---
---
---


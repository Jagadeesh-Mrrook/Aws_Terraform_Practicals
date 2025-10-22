# 🌩️ Terraform Notes — AWS VPC Creation

## 🧭 Overview

This section explains how to create an AWS VPC using Terraform — step-by-step with details on where to fetch code from, what parameters are mandatory, and how to verify.

---

## ⚙️ Step 1: Initialize Provider

### 📍 Where to Copy From:

🔗 Terraform Registry → [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### 🧱 Mandatory Fields:

* `source` → Provider name (e.g., `hashicorp/aws`)
* `version` → Provider version
* `region` → AWS region

### 🧩 Example (`provider.tf`):

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

💡 **Tip:** Never hardcode access keys here — use `aws configure` or environment variables.

---

## 🏗️ Step 2: Create VPC Resource

### 📍 Where to Copy From:

🔗 Terraform Registry → [aws_vpc Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

### 🧱 Mandatory Fields:

* `cidr_block` → Defines VPC IP range (required)

### ⚙️ Optional Fields (commonly used):

* `enable_dns_support` (default = true)
* `enable_dns_hostnames` (default = false)
* `tags`

### 🧩 Example (`vpc.tf`):

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
    Environment = "dev"
  }
}
```

---

## 📤 Step 3: Output Block

### 📍 Where to Copy From:

🔗 Terraform Registry → Check "**Attributes Reference**" section on the same `aws_vpc` page.

### 🧱 Common Attributes:

* `id` → VPC ID
* `arn` → VPC ARN
* `cidr_block` → CIDR range

### 🧩 Example (`outputs.tf`):

```hcl
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}
```

---

## 🧪 Step 4: Initialize, Validate & Apply

### Commands:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

### ✅ Verification:

* Run `terraform output` → shows created VPC ID
* Go to AWS Console → VPC → confirm CIDR and Name tag

---

## 💡 Tips & Interview Points

* CIDR must be unique; overlapping ranges cause creation failure.
* Default VPC and custom VPC are different — custom gives full control.
* Always use `tags` for cost allocation and identification.
* For multi-environment setups, define variables and use workspaces or modules.

---

## 📊 Outputs Summary

| Output Name | Description    | Example                              |
| ----------- | -------------- | ------------------------------------ |
| `vpc_id`    | Returns VPC ID | vpc-0a12b34c56d78ef90                |
| `vpc_arn`   | Returns ARN    | arn:aws:ec2:region:acct:vpc/vpc-xxxx |

---

✅ **Next Step:** Create **Subnets** inside this VPC (public & private).

---
---

# 🌐 Terraform Notes — Subnets

## Overview

This section explains how to create **AWS subnets using Terraform** in a VPC with multi-AZ support.

---

## Terraform Resource

**Resource Type:** `aws_subnet`

### Purpose / Mapping

* Each subnet exists in a single **Availability Zone (AZ)**.
* Public subnets: route to **Internet Gateway (IGW)**.
* Private subnets: route via **NAT Gateway**.
* Used for EC2, RDS, Load Balancers, and other AWS resources.

---

## Mandatory Fields

| Field                     | Description                                  |
| ------------------------- | -------------------------------------------- |
| `vpc_id`                  | ID of the VPC where subnet belongs           |
| `cidr_block`              | Subnet IP range (must be subset of VPC CIDR) |
| `availability_zone`       | Optional but recommended for multi-AZ setup  |
| `map_public_ip_on_launch` | True for public subnets, false for private   |
| `tags`                    | Recommended: Name + Environment              |

---

## Optional Fields

| Field                             | Description                 |
| --------------------------------- | --------------------------- |
| `ipv6_cidr_block`                 | For IPv6-enabled subnets    |
| `assign_ipv6_address_on_creation` | Auto-assign IPv6 addresses  |
| `outpost_arn`                     | For AWS Outposts deployment |

---

## Variables (Recommended)

* Use variables to avoid hardcoding CIDRs and AZs.
* Example variables:

```hcl
variable "public_subnet_1_cidr" { default = "10.0.1.0/24" }
variable "public_subnet_2_cidr" { default = "10.0.2.0/24" }
variable "private_subnet_1_cidr" { default = "10.0.3.0/24" }
variable "private_subnet_2_cidr" { default = "10.0.4.0/24" }
variable "az1" { default = "ap-south-1a" }
variable "az2" { default = "ap-south-1b" }
```

---

## Linking / Dependencies

* Subnets depend on **VPC (`aws_vpc.main`)**.
* Referenced by:

  * Route Tables (`aws_route_table_association`)
  * NAT Gateways (for private subnets)
  * EC2 instances, Load Balancers, RDS

---

## Terraform Outputs

* **Public Subnets:**

```hcl
output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}
```

* **Private Subnets:**

```hcl
output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}
```

* Use square brackets `[ ]` when outputting **multiple values**.
* Reference Terraform resource name, **not AWS tag Name**.

---

## Verification Steps

1. `terraform plan` → verify all 4 subnet resources.
2. `terraform apply -auto-approve` → creates subnets.
3. AWS Console → VPC → Subnets → confirm:

   * Correct CIDR ranges
   * Correct AZs
   * Public subnets have Auto-assign public IP enabled
   * Private subnets have it disabled

---

## Tricky Points / Gotchas

* CIDR overlap will cause creation failure.
* Forgetting `map_public_ip_on_launch` for public subnets → EC2 won’t get public IP.
* Terraform references **resource name**, not the AWS Name tag.
* Multiple subnets in multiple AZs are required for **high availability**.
* Square brackets `[ ]` for outputs needed when returning multiple values.

---

## Interview Tips

* Public vs Private subnets explanation.
* Purpose of `map_public_ip_on_launch`.
* Why subnets are AZ-specific.
* How Terraform links subnets with VPC, route tables, and NAT Gateway.
* Parameterizing CIDRs and AZs using variables is a best practice for reusable code.

---

✅ Next Concept: **Route Tables + Internet Gateway (AWS explanation)**

---
---

    # 🌩️ Terraform Notes — AWS Internet Gateway, Route Tables & Subnets

## 🧭 Overview

This section explains Terraform resources for Internet Gateway, Route Tables, and Subnets, focusing on route associations, locals usage, and best practices from our learning session.

---

## 1️⃣ Internet Gateway

**Resource:** `aws_internet_gateway`

### Purpose / Mapping to AWS

* Enables outbound internet access for public subnets.
* AWS manages scaling and redundancy automatically.

### Example Code

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}
```

### Verification

* EC2 in public subnet can access internet after attaching IGW and adding route.

---

## 2️⃣ Route Table

**Resource:** `aws_route_table`

### Purpose / Mapping to AWS

* Controls routing for subnets (public/private).
* Default route to local VPC CIDR is always present automatically.

### Mandatory Fields

* `vpc_id`
* `tags`

### Optional Fields / Routes

* Can define inline `route` blocks, e.g., IGW, NAT, peering.
* Alternatively, use standalone `aws_route` resource for modularity.

### Discussion Highlights

* Local route (VPC CIDR) is automatically added; no need to specify.
* For external routes, define only additional routes (IGW/NAT/Peering).
* Using `locals.tf` is recommended for storing resource IDs for reuse (e.g., `local.public_rt_id = aws_route_table.public.id`).

### Example Code (Inline Route)

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}
```

---

## 3️⃣ Route Table Association

**Resource:** `aws_route_table_association`

### Purpose / Mapping to AWS

* Associates subnets with a route table.
* Terraform automatically handles dependency if referencing `aws_subnet` and `aws_route_table` directly.

### Example Code Using Locals

```hcl
locals {
  public_rt_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = local.public_rt_id
}
```

### Discussion Highlights

* Cannot assign resource ID to `variables.tf`; must reference directly or use `locals`.
* This ensures **Terraform builds the dependency graph correctly**.

### Verification

* Check subnet route table in AWS console; ensure public subnet points to public RT with IGW route.
* Test EC2 connectivity for outbound internet.

---

## 💡 Key Discussion Points from Learning

* Default RT always contains local route to VPC CIDR.
* Custom RTs override subnet association; subnet uses the new RT instead of default.
* IGW is horizontally scaled and redundant internally by AWS.
* Terraform best practice: use **variables** for static input (CIDRs, AZs) and **locals** for resource references (IDs).
* Subnet, RT, and IGW references are **direct or via locals**, never via variables.tf for dynamic values.

---

*End of Terraform Notes — Internet Gateway, Route Tables & Subnets.*

---
---

# 🌩️ Terraform Notes — NAT Gateway & Private Subnet Routing

## **Elastic IP (EIP)**

* NAT Gateway requires an Elastic IP for public internet access.

```hcl
resource "aws_eip" "nat_eip_1" {
  vpc = true

  tags = {
    Name = "nat-eip-1"
  }
}
```

---

## **NAT Gateway**

* Must be in a **public subnet**.
* Mandatory fields: `subnet_id`, `allocation_id`

```hcl
resource "aws_nat_gateway" "nat1" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.nat_eip_1.id

  tags = {
    Name = "nat-gateway-1"
  }
}
```

**Tips:**

* NAT Gateway is AZ-specific.
* Managed, redundant, and horizontally scaled.
* Cost: per hour + data processed.

---

## **Private Subnet Route Table**

* Update `0.0.0.0/0` route to NAT Gateway.

```hcl
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
```

**Tip:**

* Use `locals.tf` for NAT Gateway or route table IDs if needed.
* Terraform handles dependency automatically when referencing `aws_nat_gateway.nat1.id`.

---

## **Multi-AZ NAT Gateway Setup**

* One NAT Gateway per AZ for HA.
* Private subnet in each AZ must point to the NAT Gateway in its AZ.

```hcl
# AZ 1
resource "aws_nat_gateway" "nat_az1" {
  subnet_id     = aws_subnet.public1.id
  allocation_id = aws_eip.nat_eip_1.id
}

resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az1.id
  }
}

# AZ 2
resource "aws_nat_gateway" "nat_az2" {
  subnet_id     = aws_subnet.public2.id
  allocation_id = aws_eip.nat_eip_2.id
}

resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az2.id
  }
}
```

**Notes:**

* This ensures private subnets in each AZ have independent NAT Gateways.
* Using NAT Instances for multi-AZ HA is possible but **not recommended** due to manual management.

---

## **Verification Steps**

* Check NAT Gateway is in **Available** state in AWS console.
* Private subnet EC2 instances can access the internet (`curl http://ifconfig.me`).
* Public subnet EC2 instances still have direct internet access via IGW.
* For multi-AZ, verify each private subnet routes through its own AZ NAT Gateway.

# 🌩️ Terraform Notes — Private NAT (Internal Routing Only)

## **Purpose / Why Use Private NAT**

* Provides **internal connectivity** for private subnets without using the public internet.
* Used in **internal routing between VPCs, AZs, or private subnets**.
* No public Elastic IP is needed; traffic remains private.

**Use Case:**

* Private subnets require routing through a private NAT for **internal network inspection, VPC-to-VPC traffic, or private services**.
* Ensures traffic never leaves AWS private network.

---

## **Terraform Implementation (Private NAT Gateway)**

* Deploy a **private NAT Gateway** in a private subnet.
* Routes for private subnets point to this NAT Gateway for **internal routing**.

```hcl
resource "aws_nat_gateway" "private_nat" {
  subnet_id         = aws_subnet.private1.id
  connectivity_type = "private"   # key argument for Private NAT

  tags = {
    Name = "private-nat-gateway"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "10.0.1.0/24"   # internal subnet/VPC range
  nat_gateway_id         = aws_nat_gateway.private_nat.id
}
```

**Notes / Tips:**

* `connectivity_type = "private"` is mandatory for internal-only NAT Gateways.
* No Elastic IP is required.
* Multi-AZ: one private NAT per AZ if routing spans multiple AZs.
* Can be used as an internal firewall, inspection, or private gateway.

---

## **Verification Steps**

* Launch EC2 in private subnet → test connectivity to other internal subnets or VPCs.
* Verify route table points internal CIDR through the private NAT Gateway.
* Ensure NAT Gateway is **Available** in AWS console.

---

## **Key Difference From Public NAT Gateway**

| Feature               | Public NAT Gateway | Private NAT Gateway      |
| --------------------- | ------------------ | ------------------------ |
| Subnet                | Public             | Private                  |
| Connectivity Type     | public             | private                  |
| Elastic IP / Internet | Required           | Not required             |
| Outbound Internet     | Yes                | No                       |
| Use case              | Internet access    | Internal private routing |


---
---

# Terraform Security Group Notes

## Concept / What

**AWS Security Group (SG)** controls inbound and outbound traffic for EC2 and other resources in a VPC. In Terraform, use the `aws_security_group` resource to create SGs and `aws_security_group_rule` to manage rules separately.

## Why / Purpose / Use Case

* Acts as a **virtual firewall** for EC2 or other AWS resources.
* Used to **allow or restrict traffic** (ports, protocols, sources/destinations).
* Ensures **secure connectivity** within VPCs and to the internet.
* Helps in **environment segregation** (dev/prod) using tags and rules.

## How it Works / Steps / Syntax

### 1️⃣ Create Security Group Resource

```hcl
resource "aws_security_group" "web_sg" {
  name        = "webserver-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "webserver-sg"
    Environment = "dev"
  }
}
```

### 2️⃣ Create Separate Ingress Rules

```hcl
# SSH from office
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["203.0.113.5/32"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow SSH from office IP"
}

# HTTP from anywhere
resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow HTTP from anywhere"
}
```

### 3️⃣ Create Separate Egress Rule

```hcl
resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow all outbound traffic"
}
```

### 4️⃣ Attach SG to EC2

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-12345"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "web-server-instance"
    Environment = "dev"
  }
}
```

## Common Issues / Errors

* SG recreation occurs if `name` changes.
* Conflicting rules when mixing inline rules with `aws_security_group_rule`.
* Forgetting to attach SG to EC2 → rules have no effect.
* Using `0.0.0.0/0` carelessly → exposes ports publicly.

## Troubleshooting / Fixes

* Use `terraform plan` to verify rule changes.
* Always reference SG ID in `vpc_security_group_ids` of EC2.
* For multiple rules, manage each with separate `aws_security_group_rule` resources.
* Avoid inline rules in SG if using separate rule resources.

## Best Practices / Tips

* Prefer `aws_security_group_rule` over inline ingress/egress.
* Provide both `name` and `tags.Name` for clarity.
* Keep rules **minimal and specific** (least privilege).
* Use descriptive `description` fields for each rule.
* Test connectivity after apply (ping/SSH/HTTP).
* Avoid `0.0.0.0/0` for SSH in production.

## Outputs

```hcl
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
```

* This ensures you can reference the SG ID in other resources or modules.

---
---

## Terraform VPC Flow Logs

### Concept / What

Terraform resource `aws_flow_log` allows you to enable VPC Flow Logs for a VPC, Subnet, or ENI. Logs can be sent to CloudWatch Logs or an S3 bucket. Flow Logs capture metadata about network traffic such as source/destination IPs, ports, protocol, and ACCEPT/REJECT actions.

### Why / Purpose / Use Case

* Automate enabling Flow Logs across environments
* Monitor network activity without manual console setup
* Maintain compliance and audit logs
* Integrate with dashboards or alerting systems

### How it Works / Steps / Syntax

#### 1️⃣ CloudWatch Logs Example

##### Step 1: Create CloudWatch Log Group

```hcl
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/vpc/flowlogs"
  retention_in_days = 30
}
```

##### Step 2: Create IAM Role for Flow Logs

```hcl
resource "aws_iam_role" "flow_logs_role" {
  name = "flow_logs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      }
    ]
  })
}
```

##### Step 3: Attach IAM Policy

```hcl
resource "aws_iam_role_policy_attachment" "flow_logs_attach" {
  role       = aws_iam_role.flow_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCCFlowLogsRole"
}
```

##### Step 4: Create VPC Flow Log

```hcl
resource "aws_flow_log" "vpc_flow_cloudwatch" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
  resource_id          = aws_vpc.first_vpc.id
  resource_type        = "VPC"
  traffic_type         = "ALL"
  max_aggregation_interval = 60

  tags = {
    Name        = "vpc-flow-log-cloudwatch"
    Environment = "dev"
  }
}
```

#### 2️⃣ S3 Destination Example

##### Step 1: Create S3 Bucket

```hcl
resource "aws_s3_bucket" "vpc_flow_logs_bucket" {
  bucket = "org-vpc-flow-logs"
  acl    = "private"

  tags = {
    Name        = "vpc-flow-logs"
    Environment = "dev"
  }
}
```

##### Step 2: Optional Bucket Policy for Flow Logs

```hcl
resource "aws_s3_bucket_policy" "flow_logs_policy" {
  bucket = aws_s3_bucket.vpc_flow_logs_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "vpc-flow-logs.amazonaws.com" }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.vpc_flow_logs_bucket.arn}/*"
      }
    ]
  })
}
```

##### Step 3: Create VPC Flow Log

```hcl
resource "aws_flow_log" "vpc_flow_s3" {
  log_destination      = aws_s3_bucket.vpc_flow_logs_bucket.arn
  resource_id          = aws_vpc.first_vpc.id
  resource_type        = "VPC"
  traffic_type         = "ALL"
  max_aggregation_interval = 60

  tags = {
    Name        = "vpc-flow-log-s3"
    Environment = "dev"
  }
}
```

### Key Points / Tips

* CloudWatch destination requires IAM Role; S3 destination requires proper bucket policy.
* `tags` are optional but recommended for naming, environment, and cost tracking.
* Ensure S3 bucket exists before creating the flow log.
* Use `max_aggregation_interval` 1 min for detailed monitoring; 10 min for lower cost.
* Terraform automatically links the flow log to the resource via `resource_id`.

### Verification

1. Terraform apply → resource created successfully
2. AWS Console → VPC → Flow Logs → Confirm Active
3. CloudWatch Logs → Verify log streams populated (CloudWatch setup)
4. S3 → Verify log files under correct path (S3 setup)

### DevOps Role (Reference)

* Responsible for enabling and managing Terraform-based Flow Logs
* Ensure log delivery, IAM permissions, retention policies
* Analysis of logs is typically handled by developers or security teams
* Focus on automation, monitoring, and reliability rather than deep SQL analytics

---
---






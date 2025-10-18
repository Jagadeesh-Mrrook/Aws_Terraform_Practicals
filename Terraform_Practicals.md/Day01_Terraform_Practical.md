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




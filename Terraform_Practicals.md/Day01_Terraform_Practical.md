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



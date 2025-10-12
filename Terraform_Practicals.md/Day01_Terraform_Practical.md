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



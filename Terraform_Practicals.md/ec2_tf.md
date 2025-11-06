## 🧩 Terraform Notes — EC2 Instances

### **Resource Name**

`aws_instance`

### **Purpose / Mapping to AWS**

Manages an EC2 instance on AWS. Maps directly to the EC2 service that launches virtual machines inside a VPC subnet.

---

### **Mandatory Fields**

| Field                    | Description                               |
| ------------------------ | ----------------------------------------- |
| `ami`                    | Defines the OS image (region-specific).   |
| `instance_type`          | CPU and memory configuration.             |
| `subnet_id`              | Subnet placement for the instance.        |
| `vpc_security_group_ids` | Controls inbound/outbound network access. |
| `key_name`               | SSH key pair for secure login.            |

---

### **Optional Fields**

| Field                                    | Description                                       |
| ---------------------------------------- | ------------------------------------------------- |
| `associate_public_ip_address`            | Assigns a public IP for internet access.          |
| `user_data`                              | Script executed on first boot for software setup. |
| `user_data_replace_on_change`            | Recreates instance if user_data changes.          |
| `iam_instance_profile`                   | Attaches IAM role for permissions.                |
| `ebs_block_device` / `root_block_device` | Attaches storage volumes.                         |
| `monitoring`                             | Enables detailed CloudWatch monitoring.           |
| `tags`                                   | Adds metadata like Name, Environment, etc.        |

---

### **Example Code Snippet**

```hcl
resource "aws_instance" "web_server" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "dev-key"
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "<h1>Terraform EC2 User Data Test</h1>" > /usr/share/nginx/html/index.html
  EOF

  user_data_replace_on_change = true

  tags = {
    Name        = "webserver-dev"
    Environment = "dev"
  }
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
```

---

### **Tips / Interview Points**

* AMI IDs are **region-specific**; use Terraform data source for dynamic retrieval.
* **User Data** automates first-boot setup using shell or PowerShell scripts.
* Use `user_data_replace_on_change = true` to re-run bootstrap scripts safely.
* Always link correct **subnet + SG** from the same VPC.
* Add **IAM instance profile** if EC2 needs AWS service access (e.g., S3, CloudWatch).
* Default **Delete on Termination = true** for root EBS volume (can override).
* **Terraform apply** will recreate EC2 if key parameters (AMI, subnet, user_data) change.

---

### **Outputs and Verification Steps**

| Step       | Command                                   | Expected Result             |
| ---------- | ----------------------------------------- | --------------------------- |
| Initialize | `terraform init`                          | AWS provider initialized    |
| Validate   | `terraform validate`                      | Syntax OK                   |
| Plan       | `terraform plan`                          | Shows EC2 creation plan     |
| Apply      | `terraform apply`                         | EC2 created                 |
| Output     | `terraform output instance_public_ip`     | Displays public IP          |
| SSH Test   | `ssh -i dev-key.pem ec2-user@<public-ip>` | Successful login            |
| Check Logs | `cat /var/log/cloud-init-output.log`      | Confirms user_data executed |

---

### **High Availability / Multi-AZ Setup Notes**

* Launch EC2 instances in multiple AZs for redundancy.
* Use **Elastic Load Balancer (ALB)** to distribute traffic across instances.
* Combine with **Auto Scaling Group (ASG)** for automatic scaling and failover.
* Use **EFS** for shared data storage across AZs.

---

### **Real-World Example — User Data (Jenkins Setup)**

```hcl
user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install java-11-amazon-corretto -y
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
EOF
```

✅ This installs Jenkins automatically when the EC2 boots up.

---

### **Interview-Focused Points**

* How to automate EC2 setup using `user_data`.
* Difference between `user_data` and manual SSH provisioning.
* Why `depends_on` is used when EC2 depends on subnet or SG creation.
* How to manage EC2 updates when AMI or scripts change.
* Importance of tagging for environment and cost tracking.

---
---

# Easy AMI Lookup Method (AWS Console → Terraform)

## 1. Open AMI Details in AWS Console

1. Go to **EC2 → AMIs** or **EC2 → Launch Instance → Select AMI**.
2. Copy the **AMI ID**.
3. Go to **EC2 → AMIs → Public images** and paste the AMI ID.
4. Open the AMI details.

## 2. Copy Two Things

* **AMI Name** (example: `ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240126`)
* **Owner ID** (example: `099720109477` for Ubuntu)

## 3. Convert AMI Name for Terraform

* Remove the last changing part (usually date or build number).
* Replace it with `*`.

### Examples

Original:

```
ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240126
```

Terraform:

```
ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*
```

Original:

```
amzn2-ami-hvm-2.0.20240207.0-x86_64-gp2
```

Terraform:

```
amzn2-ami-hvm-2.0.*-x86_64-gp2
```

## 4. Terraform Data Block

```hcl
data "aws_ami" "selected" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}
```

## Summary

* Copy AMI Name and Owner ID from console.
* Replace the last part with `*`.
* Use in a simple `data "aws_ami"` block.

---
---



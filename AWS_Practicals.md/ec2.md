## 🌐 AWS Notes — EC2 Instances

### **Definition / Purpose**

Amazon EC2 (Elastic Compute Cloud) provides resizable virtual servers (instances) that run applications on demand.
You choose the operating system (AMI), instance type (hardware capacity), key pair (access), and networking options.

**Use Cases:**

* Hosting web apps, APIs, or microservices.
* Running Dev/Test environments.
* Auto Scaling and HA deployments.

---

### **Key Sub-Concepts**

#### **1️⃣ AMI (Amazon Machine Image)**

* Blueprint for launching an instance (includes OS + configuration).
* Region-specific and can be custom-created from an existing instance.
* Example: Amazon Linux 2, Ubuntu 22.04, Windows Server.

#### **2️⃣ Instance Type**

* Defines CPU, memory, and network performance.
* Families: t (general), c (compute), m (balanced), r (memory optimized).
* Example: `t2.micro` (free tier), `m5.large` (general-purpose).

#### **3️⃣ Key Pair**

* Used for SSH authentication.
* `.pem` → Linux/macOS, `.ppk` → Windows.
* Must be created before EC2 launch or imported.

#### **4️⃣ Networking**

* Instance runs inside a **VPC** and specific **subnet**.
* **Public subnet:** internet-facing (route via IGW).
* **Private subnet:** internal, outbound internet via NAT Gateway.
* Security Groups control inbound/outbound access.

#### **5️⃣ EBS Volume**

* Persistent block storage attached to EC2.
* Root volume + optional data volumes.
* Can be detached, resized, or snapshot-backed.

#### **6️⃣ High Availability (Multi-AZ)**

* Launch EC2s across multiple AZs.
* Combine with Elastic Load Balancer (ELB) + Auto Scaling Group (ASG) for failover.

---

### **Manual Creation Steps**

1. Go to **AWS Console → EC2 → Launch Instance**.
2. Enter **Instance Name**.
3. Choose **AMI** (e.g., Amazon Linux 2).
4. Select **Instance Type** (e.g., t2.micro).
5. Select or create a **Key Pair**.
6. Under **Network Settings:**

   * Choose VPC + Subnet.
   * Enable Public IP if needed.
   * Add Security Group rule for SSH (port 22).
7. Configure **Storage (EBS)** → adjust size/type.
8. Click **Launch Instance**.
9. After creation, SSH using:

   ```bash
   ssh -i <key.pem> ec2-user@<public-ip>
   ```

---

### **Tips / Tricky Points / Gotchas**

* **AMI is region-specific.** Copy AMI if using in another region.
* **Key pair cannot be re-downloaded**; keep backup securely.
* **Without public IP or IGW**, instance won’t be reachable from the internet.
* **Private subnet instances** need NAT Gateway for outbound internet.
* **EBS Volume AZ** must match instance AZ.
* **Delete on Termination:** controls if EBS persists after instance termination.

---

### **Linking with Other Services**

* **VPC/Subnet:** EC2 placement.
* **Security Group / NACL:** Access control.
* **EBS:** Persistent storage.
* **Elastic IP:** Static public IP association.
* **ELB + ASG:** Used for scaling and high availability.
* **CloudWatch:** Monitoring metrics and alarms.
* **CloudTrail:** API-level auditing of EC2 actions.

---

### **Tagging / Naming Best Practices**

Use consistent tagging for clarity and cost tracking:

```
Name        = webserver-dev-1
Environment = dev
Project     = ecommerce-app
Owner       = devops-team
```

Tags improve management, cost visibility, and automation (like Terraform or Ansible).

---

### **High Availability Considerations**

* Deploy instances in multiple AZs within same region.
* Use **Elastic Load Balancer (ALB/NLB)** for traffic distribution.
* Use **Auto Scaling Group** for instance replacement.
* Store shared data in **EFS** or replicated EBS snapshots.

---

### **Verification Steps**

* **SSH Test:** `ssh -i key.pem ec2-user@<public-ip>`
* **Check Volume:** `lsblk` → Verify attached EBS volumes.
* **Network Check:** Ping 8.8.8.8 (public subnet) or use NAT Gateway in private.
* **Console Check:** Confirm VPC, subnet, SG, tags, and public IP in EC2 dashboard.

---

### **Interview-Focused Points**

* Difference between **AMI**, **instance type**, and **key pair**.
* Why **private subnet** instances can’t access internet directly.
* Role of **NAT Gateway** and **IGW** in EC2 networking.
* Importance of **Multi-AZ** deployment for fault tolerance.
* Impact of **Delete on termination** on EBS persistence.
* How to recover if **key pair is lost** (create new key + attach via user data/SSM).
* Explain **Security Group vs NACL** differences.

---
---


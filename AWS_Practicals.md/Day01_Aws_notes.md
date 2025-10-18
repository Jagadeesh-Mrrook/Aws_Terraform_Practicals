# VPC — AWS Notes

**Definition / Purpose**
A Virtual Private Cloud (VPC) is a logically isolated virtual network in AWS where you launch AWS resources. Think of it as your private data center within the cloud.

---

## Key Sub-Concepts

* **CIDR Block:** IPv4 range (e.g., `10.0.0.0/16`) defines the IP address space for the VPC.
* **Subnets:** Subdivisions of the VPC CIDR (public/private) placed in AZs.
* **Route Tables:** Control routing between subnets, IGW, NAT, and peering.
* **Internet Gateway (IGW):** Enables internet access for public subnets.
* **NAT Gateway / NAT Instance:** Allows outbound internet from private subnets.
* **Security Groups:** Instance-level stateful firewall.
* **Network ACLs (NACLs):** Subnet-level stateless firewall.
* **DHCP Options:** Domain name, DNS servers, NTP, etc. for instances.
* **DNS:** `enableDnsSupport` and `enableDnsHostnames` control internal DNS.
* **Flow Logs:** Capture IP traffic for monitoring and troubleshooting.
* **Secondary CIDRs:** Add additional CIDR blocks to expand address space.
* **VPC Peering / Endpoints / Hybrid Networking:** Connect VPCs, access S3/ DynamoDB privately, or connect on-prem.

---

## Manual Console Creation Steps (Quick)

1. AWS Console → VPC → **Your VPCs** → **Create VPC**
2. Choose **VPC only** → give **Name**, **CIDR** (e.g., `10.0.0.0/16`) → **Create**
3. Verify DNS settings: VPC → Select → **Actions → Edit DNS hostnames/resolution** → `true` for both
4. Tag the VPC: `Name`, `Environment`, `Owner`

---

## Tips / Tricky Points / Gotchas

* **CIDR overlap:** Never create overlapping CIDRs when planning peering or VPNs.
* **DNS hostnames:** If `enable_dns_hostnames` is false, EC2 instances won't get public DNS names.
* **Default VPC vs. Custom VPC:** Default is auto-created. Use custom VPC for production.
* **IP range limits:** CIDR must be between `/16` and `/28` for creation.
* **Secondary CIDR:** Can be added later but primary CIDR cannot be changed.
* **Tenancy:** `default` vs `dedicated` (cost and availability implications).
* **NACLs are stateless:** Must add explicit return rules.

---

## Linking with Other Services

* **EC2, RDS, ElastiCache, EFS** all use VPC/subnets.
* **Route Tables** link subnets to IGW/NAT or peering connections.
* **VPC Endpoints** (Interface/Gateway) provide private access to AWS services.
* **Transit Gateway** simplifies complex multi-VPC/hybrid connectivity.

---

## Tagging / Naming Best Practices

* Use consistent tags: `Name`, `Environment`, `Owner`, `Project`, `CostCenter`.
* Example name: `project-env-vpc` → `payments-dev-vpc`.

---

## High Availability Considerations

* Spread subnets across **multiple AZs** for HA.
* Use NAT Gateways per AZ (or autoscaling NAT instances) to avoid single-AZ failure.
* Route tables and endpoints should be designed per-AZ when required.

---

## Verification Steps

* Console: VPC → Your VPCs → check CIDR, DNS hostnames/resolution, tags.
* Launch an EC2 in a subnet inside the VPC and test:

  * Private connectivity: `ping`/`ssh` between instances (where allowed).
  * Public connectivity (if public subnet + IGW and SG allow): `curl http://ifconfig.me`.
* Validate Flow Logs in CloudWatch or S3 if enabled.

---

## Interview-Focused Points

* Explain difference between **Security Groups** and **NACLs** (stateful vs stateless).
* Describe how **DNS hostnames** + **DNS resolution** affect instance reachability.
* Be ready to talk about **CIDR planning** for hybrid connectivity and peering.
* Know how to **add secondary CIDR** and why it's useful.

---

*End of VPC AWS Notes.*
---
---

# 🌐 AWS Notes — Subnets

## Definition / Purpose

A **subnet** is a range of IP addresses within a VPC that resides in a single **Availability Zone (AZ)**.

* Public subnets: Internet-facing, route to **IGW**.
* Private subnets: Internal, route to **NAT Gateway** for outbound internet.

## Key Sub-Concepts

* **CIDR Block:** Must be a subset of the VPC CIDR. Example:

  * VPC = `10.0.0.0/16`
  * Subnet = `10.0.1.0/24` (256 IPs)
* **AZ-specific:** Each subnet exists in a single AZ.
* **Subnet Types:**

  * Public → route to IGW
  * Private → route via NAT
* **High Availability:** Create subnets in multiple AZs.

## Manual Creation Steps

1. Go to **AWS Console → VPC → Subnets → Create Subnet**.
2. Select **VPC**.
3. Enter **Name tag** (e.g., `payments-public-1`).
4. Choose **Availability Zone** (AZ).
5. Enter **IPv4 CIDR block** (subset of VPC).
6. Click **Create Subnet**.
7. Repeat for multiple subnets in different AZs and types (public/private).

## Tips / Tricky Points / Gotchas

* CIDR **must not overlap** within the VPC.
* Public subnets require **route table pointing to IGW** to be internet-facing.
* Private subnets will need **NAT Gateway** for outbound internet.
* Each subnet is **AZ-specific**; plan multiple AZs for HA.
* Maximum subnets per VPC: **200 by default**.

## Linking with Other Services

* EC2, RDS, Lambda instances use the subnet’s CIDR, routing, and SG/NACL rules.
* NAT Gateway must reside in **public subnet** for private subnet outbound connectivity.
* Route tables define traffic flow for public/private subnets.

## Tagging / Naming Best Practices

* Use consistent tags:

  * `Name` → e.g., `payments-public-1`
  * `Environment` → `dev`, `prod`
  * `Project` → e.g., `payments`
* Helps in management, cost allocation, and automation.

## High Availability Considerations

* Create **at least one public + one private subnet per AZ**.
* Multi-AZ subnets allow EC2/RDS failover.
* NAT Gateway should ideally be **one per AZ** to avoid single point of failure.

## Verification Steps

* Console → VPC → Subnets → check: CIDR, AZ, and tags.
* Launch EC2 in public subnet → verify public IP, ping external IP.
* Launch EC2 in private subnet → verify no public IP, test NAT access later.
* Optional: ping between instances in the same VPC.

## Interview-Focused Points

* Difference between **public vs private subnet**.
* Why **NAT Gateway** is needed for private subnet.
* How subnet CIDR planning affects **scalability** and **future peering**.
* Subnets are **AZ-specific** → explain importance for **HA**.

---
---

# 🌐 AWS Notes — Subnets, IGW, Route Tables, and Subnet Associations

## **1️⃣ Internet Gateway (IGW)**

**Definition / Purpose**

* Horizontally scaled, AWS-managed gateway for **public subnet internet access**.
* Only **one IGW per VPC** is allowed.
* Provides outbound path to the internet and allows return traffic for stateful connections.

**Manual Console Creation Steps**

1. AWS Console → VPC → Internet Gateways → Create Internet Gateway
2. Provide a **Name** → Create
3. Select IGW → Actions → Attach to VPC → Choose your VPC → Attach

**Tricky Points / Gotchas**

* Only one IGW per VPC.
* Cannot delete while attached to a VPC.
* IGW does **not control inbound filtering** — Security Groups/NACLs do.

**Verification Steps**

* Check IGW state = attached
* Launch EC2 in a public subnet → test internet access (`curl http://ifconfig.me`)

**Key Concept**

* IGW is mostly for **outbound traffic**, but return traffic comes back automatically for allowed connections.

---

## **2️⃣ Route Tables (RT)**

**Definition / Purpose**

* Controls **how traffic flows** from subnets.
* Every VPC has **one default RT** with a `local` route for intra-VPC communication.
* Custom RTs separate **public/private subnet traffic** and define internet access paths.

**Manual Console Creation Steps**

1. VPC → Route Tables → Create Route Table → Name + VPC → Create
2. Add routes:

   * Public RT: Destination = `0.0.0.0/0` → Target = IGW
   * Private RT: Destination = `0.0.0.0/0` → Target = NAT Gateway (later)
3. Subnet Associations → Edit Subnet Associations → select subnets → Save

**Tricky Points / Gotchas**

* Default RT cannot be deleted.
* Subnet can only be associated with **one RT at a time**.
* Associating subnet with custom RT **removes it from default RT**.
* `Local` route cannot be removed — ensures **intra-VPC traffic**.

**Verification Steps**

* Check subnet associations in Route Table console
* Launch EC2 instances → test connectivity:

  * Public → Internet (via IGW)
  * Private → No internet until NAT is added
  * Both → Can talk to each other internally (local route)

**Interview Points**

* Default RT vs Custom RT behavior
* Local route allows **intra-VPC communication**
* A subnet can have only **one route table association**

---

## **3️⃣ Subnet Associations**

**Definition / Purpose**

* Assigns a **subnet to a specific RT**, controlling its traffic paths.

**Manual Console Steps**

1. Route Table → Subnet Associations → Edit Subnet Associations
2. Select subnets → Save

**Tricky Points / Gotchas**

* A subnet can only be associated with **one RT** at a time.
* Subnet associated with custom RT **stops using default RT**.
* Default RT still exists in the VPC but may be **unused**.

**Verification Steps**

* Check that subnets are listed under the correct RT
* Test connectivity to confirm outbound/inbound behavior per RT

**Key Concept**

* Route tables + subnet associations control the **path of traffic**, but actual **filtering is done via SGs/NACLs**.

---

## **4️⃣ Outbound vs Inbound Clarification**

* **Outbound traffic:** controlled by **route tables + IGW/NAT**
* **Inbound traffic:** controlled by **Security Groups (stateful) and NACLs (stateless)**
* Subnets and IGW only provide **the path**; they do not filter traffic

**Example:**

* Public subnet instance → IGW → Internet (allowed by RT)
* Return traffic comes back automatically (stateful)
* Security Groups/NACLs decide if traffic is actually allowed to reach the instance

**Key Interview Points**

* Default RT cannot be deleted, but subnets can move to custom RTs
* Intra-VPC communication is allowed by `local` route unless blocked by SG/NACL
* IGW provides a pathway for outbound traffic; inbound filtering requires SG/NACL configuration

---
---



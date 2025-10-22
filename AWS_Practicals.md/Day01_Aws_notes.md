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

# 🌩️ AWS Notes — NAT Gateway & Private Subnet Routing

## **Definition / Purpose**

* NAT Gateway allows **instances in private subnets** to access the internet for outbound traffic only.
* Private instances remain **inaccessible from the internet**.
* Managed by AWS: redundant and horizontally scaled **within an AZ**.

---

## **Key Sub-Concepts**

1. **Elastic IP (EIP):** NAT Gateway requires a public IP to route traffic.
2. **Public Subnet:** NAT Gateway must reside in a subnet with **IGW access**.
3. **Route Table Update:** Private subnets route `0.0.0.0/0` through NAT Gateway.

---

## **Manual Console Creation Steps**

1. **Allocate an Elastic IP:** VPC → Elastic IPs → Allocate new EIP.
2. **Create NAT Gateway:** VPC → NAT Gateways → Create NAT Gateway.

   * Subnet: Choose a **public subnet**.
   * Elastic IP: Select the allocated EIP.
3. **Update Private Subnet Route Table:**

   * Route Tables → Select private RT → Edit routes → Add route:

     * Destination: `0.0.0.0/0`
     * Target: NAT Gateway ID
4. **Verify creation:** NAT Gateway shows **Available** state.

---

## **Tips / Tricky Points / Gotchas**

* **One NAT Gateway per AZ** is required for HA; each private subnet must point to the NAT in its AZ.
* **Elastic IP cost:** Billed per hour + data processed.
* **Private subnet must not have IGW route**; otherwise, NAT Gateway is bypassed.
* NAT Gateway handles **outbound traffic only**; inbound connections from internet are blocked.
* **Alternative for Multi-AZ HA:** Older setups used **NAT Instances** in each AZ.

  * These required manual management (scaling, failover, patching).
  * Not recommended by most organizations today; NAT Gateway is preferred.

---

## **Verification Steps**

* Launch an EC2 instance in a **private subnet**.
* Test outbound internet access: `ping 8.8.8.8` or `curl http://ifconfig.me`.
* Confirm private instance uses NAT Gateway’s EIP for outbound traffic.
* Ensure public subnet still has direct internet access via IGW.

---

## **High Availability Considerations**

* Multi-AZ setup: Create one NAT Gateway in **each AZ**.
* Update route tables in each private subnet to point to the NAT Gateway in its own AZ.
* Using NAT Instances for multi-AZ HA is possible but **not recommended** due to management overhead.

---

## **Interview-Focused Points**

* Difference between **IGW and NAT Gateway**.
* Why NAT Gateway resides in **public subnet**.
* Multi-AZ NAT Gateway deployment for HA.
* Cost comparison: NAT Gateway vs NAT Instance (legacy approach).

---
---

🌩️ AWS Notes — Security Groups (SG)

**Definition / Purpose**

* Security Groups act as virtual firewalls for resources in a VPC.
* Control inbound and outbound traffic at the instance (ENI) level.
* Stateful: return traffic is automatically allowed, even if no explicit outbound rule exists.

**Key Sub-Concepts**

* **Resource Association:** Can be attached to EC2, RDS, ELB, Lambda in VPC, ElastiCache, Redshift, and other services with ENIs.
* **Inbound & Outbound Rules:** Specify protocol, port range, and source/destination IP or SG.
* **Default SG:** Automatically created per VPC; allows all inbound traffic from resources in the same SG and all outbound traffic.
* **Multiple SGs:** A single ENI/resource can have multiple SGs attached; rules are cumulative.

**Manual Console Creation Steps**

1. **Create Security Group:** VPC → Security Groups → Create Security Group.

   * Name: Provide a name and description.
   * VPC: Select the VPC.
2. **Add Inbound Rules:**

   * Protocol, Port Range, Source (IP/CIDR or another SG).
3. **Add Outbound Rules:**

   * Protocol, Port Range, Destination (IP/CIDR or another SG).
4. **Associate with Resource:**

   * EC2 → Network & Security → Change Security Groups → Select SG(s).

**Tips / Tricky Points / Gotchas**

* Security Groups are **stateful**; NACLs are stateless.
* SGs are **per ENI**, not per VPC.
* **Default SG behavior:** inbound from same SG allowed, outbound all allowed.
* **Rule evaluation:** All rules are permissive; there is no deny.
* Best practice: Use **least privilege rules** to minimize exposure.

**Verification Steps**

* Launch an EC2 instance and attach SG.
* Test connectivity according to inbound/outbound rules (ping, curl, SSH).
* Confirm access is blocked or allowed as per SG rules.

**Interview-Focused Points**

* Difference between SG (stateful) and NACL (stateless).
* Default SG behavior in a new VPC.
* SG association with ENI vs resource.
* Best practices for securing instances using SGs.

---
---

## Network Access Control List (NACL) - AWS Notes

### Concept / What

A **Network ACL (NACL)** is a **subnet-level firewall** in AWS that controls **inbound and outbound traffic**. It is **stateless**, meaning return traffic must be explicitly allowed.

### Why / Purpose / Use Case

* Provides **subnet-level security**.
* Useful for **controlling traffic for multiple instances** in a subnet.
* Can be used alongside Security Groups for **defense-in-depth**.
* Helps meet **compliance requirements** for network isolation.

### How it Works / Steps / Syntax (AWS Console)

1. **Navigate to VPC Dashboard** → Network ACLs → Create Network ACL.
2. **Configure Basic Settings:**

   * Name tag (e.g., `my-nacl`)
   * VPC selection
3. **Inbound Rules:**

   * Add rules with Rule #, Type, Protocol, Port Range, Source, and Action (ALLOW/DENY)
4. **Outbound Rules:**

   * Add rules with Rule #, Type, Protocol, Port Range, Destination, and Action
5. **Subnet Association:**

   * Associate the NACL with one or more subnets
6. **Verification:**

   * Launch EC2 in the subnet
   * Test allowed ports (SSH, HTTP)
   * Test blocked ports to ensure DENY works

### Common Issues / Errors

* Traffic blocked unexpectedly due to **first-match rule logic**.
* Forgetting to allow return traffic for **stateless NACLs**.
* Trying to reuse **same rule number** → AWS error.
* Misunderstanding the **default NACL** behavior.

### Troubleshooting / Fixes

* Always check **rule numbers** and evaluation order.
* Ensure **return traffic** is explicitly allowed.
* Use different rule numbers (e.g., 100, 110, 120) and leave gaps.
* Verify subnet association.

### Best Practices / Tips

* Keep NACLs **simple**; use SGs for fine-grained security.
* Use **first-match logic** carefully; order your rules properly.
* Default deny (`*`) is always applied for unmatched traffic.
* Keep one NACL per subnet for clarity.
* Leave gaps between rule numbers for easy modifications.
* Remember: **both NACL and SG must allow traffic** for it to pass.

### Special Scenarios / Interview Tips

* **SG vs NACL:** SG = instance-level (stateful), NACL = subnet-level (stateless).
* **Allow + Deny on same traffic:** First-match wins; DENY takes effect if it’s the first match.
* **Default behavior:** Custom NACL = deny all, Default AWS NACL = allow all.
* **Rule number uniqueness:** Cannot have duplicate rule numbers in a NACL.
* **`*` rule:** Implicit deny for any traffic not matching existing rules.

### Example

| Rule # | Type | Port | Source/Destination | Action          |
| ------ | ---- | ---- | ------------------ | --------------- |
| 100    | SSH  | 22   | 0.0.0.0/0          | ALLOW           |
| 110    | HTTP | 80   | 0.0.0.0/0          | ALLOW           |
| *      | All  | All  | All                | DENY (implicit) |

---
---

## VPC Flow Logs

### Concept / What

VPC Flow Logs capture metadata about IP traffic going to and from network interfaces (ENIs) in a VPC, subnet, or specific interface. They log information such as source/destination IPs, ports, protocol, and whether traffic was accepted or rejected. Payloads are not logged.

### Why / Purpose / Use Case

* Troubleshoot connectivity issues (SG/NACL mismatches)
* Monitor network activity and detect anomalies
* Audit network traffic for compliance
* Analyze bandwidth usage and optimize cost

### How it Works / Steps / Syntax (AWS Console)

1. **Navigate to VPC**: AWS Console → VPC → Your VPCs → Select VPC
2. **Create Flow Log**: Actions → Create flow log
3. **Define Log Details**:

   * **Filter** (Mandatory): ALL, ACCEPT, REJECT
   * **Max aggregation interval** (Optional): 1 or 10 minutes
   * **Destination** (Mandatory): CloudWatch Logs or S3
   * **IAM Role** (Mandatory if CloudWatch selected): Allows publishing logs
4. **Select Resource Type**: VPC (recommended), Subnet, or ENI
5. **Create Flow Log**: Click Create Flow Log
6. **Verify Logs**:

   * CloudWatch Logs → Log Group → Log Streams
   * S3 → Bucket path `/AWSLogs/<account-id>/vpcflowlogs/...`
   * Example log entry:

     ```
     2 123456789012 eni-12345 10.0.1.10 172.31.0.2 443 51200 6 10 1000 ACCEPT OK
     ```

### Common Issues / Errors

* No logs appearing → IAM role or destination misconfigured
* Only ACCEPT logs showing → Filter incorrectly set
* High volume → Cost can increase
* S3 empty → Wrong bucket policy/region

### Troubleshooting / Fixes

* Verify IAM role permissions for CloudWatch Logs or S3
* Ensure bucket policies allow write access
* Use CloudWatch Logs Insights for quick queries
* Monitor log volume and adjust aggregation interval if needed

### Best Practices / Tips

* Start with Filter = ALL for complete visibility
* Use CloudWatch for real-time analysis, S3 for long-term storage
* Avoid enabling Flow Logs for every ENI unless necessary
* Set aggregation interval = 1 min for detailed monitoring
* Partition S3 logs for cost-effective querying with Athena if needed

### DevOps Role (Realistic Interview Answer)

* Responsible for **enabling and managing VPC Flow Logs**, ensuring logs reach CloudWatch or S3
* Verify IAM permissions and log delivery
* Set retention policies and monitor for anomalies
* Analysis of logs (queries, SQL in Athena) was typically handled by **developers or security team**
* DevOps focused on setup, reliability, and monitoring, not deep data analytics

---
---



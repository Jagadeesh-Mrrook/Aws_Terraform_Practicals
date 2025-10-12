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



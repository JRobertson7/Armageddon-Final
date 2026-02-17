# Lab 3 – Cross-Region Architecture with Transit Gateway (APPI-Compliant) UNFINSHED

## Overview

This lab builds a **cross-region, production-style architecture** using AWS Transit Gateway and Terraform.
The design simulates a **regulated healthcare environment** where sensitive data must remain in its country of origin while still being accessible by applications in other regions.

The lab demonstrates how to:

* Connect multiple AWS regions securely
* Keep regulated data in its required jurisdiction
* Provide a single global application endpoint

---

## Architecture

**Global Users → ALB / Global URL → São Paulo App Layer → Transit Gateway → Tokyo Data Layer → RDS**

### Region Roles

**Tokyo (ap-northeast-1)**

* Data authority region
* Hosts the RDS database
* Stores all sensitive medical data (PHI)

**São Paulo (sa-east-1)**

* Compute extension region
* Hosts application servers
* Connects to Tokyo over Transit Gateway

---

## Key Design Principles

* Patient data must **remain in Japan** (APPI compliance).
* Application compute can run in another region.
* Regions communicate via **Transit Gateway peering**.
* All traffic flows through a **single public endpoint**.

---

## Technologies Used

* **Terraform**
* **AWS Transit Gateway**
* **VPC Peering via TGW**
* **Application Load Balancer**
* **Amazon EC2**
* **Amazon RDS (Tokyo only)**
* **Route53 (optional global DNS)**

---

## Lab Objectives

### Core Goals

* Deploy two VPCs in separate regions.
* Create a Transit Gateway in each region.
* Peer the Transit Gateways across regions.
* Route application traffic from São Paulo to Tokyo.
* Keep all database storage inside Tokyo.

### Operational Goals

* Manage each region with **separate Terraform state**.
* Apply infrastructure in the correct order.
* Pass cross-region values between environments.

---

## Deployment Order (Critical)

Apply resources in this exact sequence:

### Step 1 – Tokyo (Data Region)

Apply Tokyo stack **without** peering variables:

```bash
terraform apply
```

---

### Step 2 – São Paulo (Compute Region)

Apply São Paulo stack:

```bash
terraform apply
```

Capture outputs:

* `saopaulo_tgw_id`
* `saopaulo_vpc_cidr`

---

### Step 3 – Update Tokyo Variables

Provide São Paulo values to Tokyo:

```bash
terraform apply \
  -var="saopaulo_tgw_id=<VALUE>" \
  -var="saopaulo_vpc_cidr=<VALUE>"
```

---

### Step 4 – Re-apply São Paulo

Complete peering and routing:

```bash
terraform apply
```

---

## Network Flow

1. User sends request to global application URL.
2. Traffic reaches São Paulo application servers.
3. App connects to Tokyo RDS via Transit Gateway.
4. Database response returns over the same path.

Sensitive data never leaves Tokyo.

---

## Verification Steps

### 1) Transit Gateway peering is active

```bash
aws ec2 describe-transit-gateway-peering-attachments \
  --region ap-northeast-1
```

Expected:

```
State: available
```

---

### 2) Cross-region connectivity works

From São Paulo EC2:

```bash
ping <TOKYO_RDS_PRIVATE_IP>
```

Or test the application endpoint.

---

### 3) Database exists only in Tokyo

```bash
aws rds describe-db-instances --region ap-northeast-1
```

Expected:

* RDS instance present in Tokyo

Check São Paulo:

```bash
aws rds describe-db-instances --region sa-east-1
```

Expected:

* No database instances

---

## Compliance Scenario (APPI Context)

Japan’s **Act on the Protection of Personal Information (APPI)** requires strict control over personal data.

For healthcare:

* Patient data must remain inside Japan.
* Cross-border access must be controlled and logged.
* The safest architecture keeps storage in-country.

This lab models a real-world pattern used by:

* Healthcare platforms
* Financial institutions
* Government services

---

## Common Failure Scenarios

### Failure A – No cross-region routing

**Cause:** Missing TGW route table entries
**Fix:** Add routes in both regions pointing to the peering attachment

---

### Failure B – Peering stuck in “pending”

**Cause:** Only one side applied
**Fix:** Re-apply the second region after peering variables are set

---

### Failure C – App cannot reach database

**Cause:** Security group or CIDR mismatch
**Fix:** Allow inbound DB traffic from São Paulo VPC CIDR

---

## Key Learning Outcomes

* How to design cross-region architectures.
* How to keep regulated data in the correct jurisdiction.
* How Transit Gateway peering works.
* Why deployment order matters in multi-region Terraform.

---

## Cleanup

Destroy each region separately:

### São Paulo

```bash
terraform destroy
```

### Tokyo

```bash
terraform destroy
```

Always destroy the **compute region first**, then the data region.

---

## Author

**Jimmy Robertson**
DevSecOps / Cloud Engineering Labs

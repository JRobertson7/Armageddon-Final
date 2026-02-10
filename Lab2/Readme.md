# Lab 2 – CloudFront Origin Cloaking & Cache Correctness (Lab 2B)

## Overview

This lab implements a **secure, production-style web architecture** using AWS services and Terraform.
The goal is to ensure that **CloudFront is the only public entry point**, while the Application Load Balancer (ALB) and backend resources remain protected.
The lab also focuses on **correct caching behavior** to prevent data leaks, stale reads, and performance issues.

---

## Architecture

**Internet → CloudFront (+ WAF) → ALB (origin-cloaked) → Private EC2 → RDS**

### Key security and design goals

* Only CloudFront is publicly reachable.
* ALB accepts traffic **only from CloudFront**.
* WAF is enforced at the CloudFront edge.
* Private EC2 instances have no public IP.
* Database is isolated inside private subnets.

---

## Technologies Used

* **Terraform**
* **AWS CloudFront**
* **AWS WAFv2 (CLOUDFRONT scope)**
* **Application Load Balancer (ALB)**
* **Amazon EC2 (private)**
* **Amazon RDS**
* **AWS ACM (TLS certificates)**
* **Route53 (optional DNS)**

---

## Lab Objectives

### Lab 2 – Origin Cloaking

* Restrict ALB access to CloudFront only.
* Use AWS-managed CloudFront prefix list.
* Require a **secret custom header** for ALB forwarding.
* Move WAF from ALB to CloudFront.
* Point DNS to CloudFront instead of ALB.

### Lab 2B – Cache Correctness

* Separate **cache key** from **origin forwarding**.
* Aggressively cache static content.
* Disable caching for dynamic API endpoints.
* Prevent:

  * User data leaks
  * Stale reads after writes
  * Cache fragmentation

---

## Cache Behavior Design

| Path               | Cache Policy          | Origin Request Policy   | Purpose                        |
| ------------------ | --------------------- | ----------------------- | ------------------------------ |
| `/static/*`        | Aggressive caching    | Minimal forwarding      | Fast, low-cost static delivery |
| `/api/*`           | Caching disabled      | Forward required values | Safe dynamic API behavior      |
| `/api/public-feed` | Origin-driven caching | API forwarding policy   | Cache only when origin allows  |

---

## Failure Scenarios Covered

### Failure A – User data leak

* Cause: Cached API responses without user identity in cache key.
* Fix: Disable caching for personalized APIs.

### Failure B – Random 403 errors

* Cause: Forwarding too many headers.
* Fix: Whitelist only required headers.

### Failure C – Cache hit ratio collapse

* Cause: Too many values in cache key.
* Fix: Keep cache key minimal.

---

## Verification Steps

### 1) Only CloudFront is public

Direct ALB request should fail:

```bash
curl -I https://<ALB_DNS_NAME>
```

Expected:

```
403 Forbidden
```

CloudFront request should succeed:

```bash
curl -I https://<CLOUDFRONT_DOMAIN>
```

---

### 2) Static caching works

```bash
curl -i https://<CLOUDFRONT_DOMAIN>/static/index.html
curl -i https://<CLOUDFRONT_DOMAIN>/static/index.html
```

Expected:

* First: `Miss from cloudfront`
* Second: `Hit from cloudfront`
* `Age` header increases

---

### 3) API safe default (no caching)

```bash
curl -i https://<CLOUDFRONT_DOMAIN>/api/list
curl -i https://<CLOUDFRONT_DOMAIN>/api/list
```

Expected:

* No consistent cache hit
* No increasing `Age` header

---

## Honors: Origin-Driven Caching

Public endpoint:

```
GET /api/public-feed
Cache-Control: public, s-maxage=30, max-age=0
```

Test:

```bash
curl -i https://<DOMAIN>/api/public-feed
curl -i https://<DOMAIN>/api/public-feed
sleep 35
curl -i https://<DOMAIN>/api/public-feed
```

Expected:

* Miss → Hit → Miss after TTL

---

## Honors+ – Controlled Invalidation

Invalidate only specific paths:

```bash
aws cloudfront create-invalidation \
  --distribution-id <DIST_ID> \
  --paths "/static/index.html"
```

Never invalidate:

```
/*
```

unless there is a security or legal emergency.

---

## Deployment Instructions

Initialize Terraform:

```bash
terraform init
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply
```

Destroy after lab:

```bash
terraform destroy
```

---

## Key Learning Outcomes

* How to securely expose applications through CloudFront.
* Difference between **cache policy** and **origin request policy**.
* How misconfigured caching causes real production incidents.
* How to safely manage CloudFront invalidations.

---

## Author

**Jimmy Robertson**
DevSecOps / Cloud Engineering Labs

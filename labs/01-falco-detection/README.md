# Lab 01: Docker Security Benchmarking

## Overview

This lab uses Docker Bench Security to audit your Docker installation against CIS Docker Benchmark best practices. Unlike kernel-level tools, this works on **all platforms**.

## Platform Compatibility

✅ **Works everywhere:**
- macOS (Docker Desktop)
- Linux (all distributions)
- Windows WSL2
- Azure/AWS/GCP VMs
- Bare metal

## What You'll Learn

- CIS Docker Benchmark standards
- Docker daemon security configuration
- Container runtime security
- Host security configuration
- Network and storage security

## Lab Steps

### 1. Run Security Audit

```bash
./run-audit.sh
```

This runs Docker Bench Security against your system.

### 2. Review Results

```bash
./view-results.sh
```

Shows categorized security findings:
- [PASS] - Configuration meets security standards
- [WARN] - Potential security issues
- [INFO] - Informational findings
- [NOTE] - Manual verification needed

### 3. Fix Issues (Optional)

```bash
./show-fixes.sh
```

Shows how to fix common issues found.

## What Gets Checked

**Host Configuration:**
- Separate partition for Docker
- Docker daemon configuration
- Audit logging

**Docker Daemon:**
- TLS authentication
- User namespaces
- Content trust
- Authorization plugins

**Container Images:**
- Trusted base images
- No unnecessary packages
- User configuration

**Container Runtime:**
- AppArmor/SELinux profiles
- Capability restrictions
- Resource limits
- Read-only filesystems

**Docker Security Operations:**
- Logging configuration
- Secret management
- Swarm mode (if applicable)

## Understanding Results

### PASS Example
```
[PASS] 2.1 - Ensure network traffic is restricted between containers
```
Your configuration is secure.

### WARN Example
```
[WARN] 2.8 - Enable user namespace support
```
Action needed to improve security.

### INFO Example
```
[INFO] 4.1 - Ensure a user for the container has been created
```
Verify manually in your containers.

## Cleanup

```bash
./cleanup.sh
```

## Key Takeaways

- **CIS Benchmarks** provide security baselines
- **Automated auditing** finds misconfigurations quickly
- **Defense in depth** requires multiple security layers
- **Regular audits** catch configuration drift

This tool is what security teams actually use in production!

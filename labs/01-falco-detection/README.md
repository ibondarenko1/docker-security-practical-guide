# Lab 01: Falco Runtime Detection

## ⚠️ Platform Requirements

**✅ Linux Required** - This lab needs direct kernel access

**❌ macOS Not Supported** - Docker Desktop's VM architecture prevents kernel monitoring

**Windows WSL2** - Should work (untested in this guide)

## For macOS Users

**Recommendation: Skip to Lab 02** which works identically on all platforms.

If you want to complete this lab:

### Option 1: Use a Linux VM (Easiest)
```bash
# Install UTM (free) or Parallels/VirtualBox
# Create Ubuntu VM
# Install Docker in the VM
# Clone this repo in the VM
# Run Lab 01
```

### Option 2: Use Colima
```bash
brew install colima
colima start --cpu 4 --memory 8
# Colima provides better Linux compatibility than Docker Desktop
```

### Option 3: Cloud Instance
```bash
# Spin up free tier AWS EC2 / GCP Compute / Azure VM
# SSH in and run the lab
```

### Why This Limitation?

Falco monitors system calls at the kernel level. Docker Desktop on macOS runs containers in a lightweight VM (LinuxKit) that doesn't expose kernel interfaces Falco needs. This is a fundamental architectural limitation, not a bug.

**This is educational!** Real-world security tools have platform constraints. Understanding these limitations is part of security engineering.

## For Linux Users

### Objectives
- Deploy Falco for runtime security monitoring
- Detect suspicious container behavior
- Create custom detection rules
- Analyze security events

### Prerequisites
- Linux kernel 4.14+
- Docker installed
- Root/sudo access

### Steps

#### 1. Deploy Falco
```bash
./deploy-falco.sh
```

#### 2. Run Attack Scenarios
```bash
./attack-scenarios.sh
```

#### 3. Analyze Alerts
```bash
docker logs -f falco
```

### Expected Outcomes

Falco should detect:
- Sensitive file access (`/etc/shadow`, `/etc/sudoers`)
- Network scanning activity
- Privilege escalation attempts
- Suspicious binary execution

### Cleanup
```bash
./cleanup.sh
```

## Learning Objectives

Whether you run this lab or skip it, you've learned:

1. **Kernel-level monitoring** requires direct kernel access
2. **Platform constraints** affect security tool selection
3. **Trade-offs exist** between convenience (Docker Desktop) and capabilities (full Linux)
4. **Real-world security** involves working within platform limitations

## Alternative: Watch It Work

If you can't run this lab, search YouTube for "Falco container security demo" to see it in action.

## Next Steps

Continue to **Lab 02: Secure Configurations** which works on all platforms and teaches critical container hardening techniques.

```bash
cd ../02-secure-configs
cat README.md
```

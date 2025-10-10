# Lab 01: Docker Security Auditing with Docker Bench Security

## Overview

This lab introduces you to **Docker Bench Security**, the official security auditing tool from Docker. It checks for common best practices around deploying Docker containers in production based on the CIS Docker Benchmark.

### What You'll Learn

- How to audit Docker security configurations
- Understanding CIS Docker Benchmark compliance
- Identifying common security misconfigurations
- Best practices for secure Docker deployments

## Prerequisites

- Docker installed and running
- Basic understanding of Docker containers
- Terminal/command line access

## Lab Components

### 1. Docker Bench Security

Docker Bench Security is a script that checks for dozens of common best practices around deploying Docker containers in production. The tests are automated and based on the CIS Docker Benchmark.

**Key Features:**
- Automated security checks
- Based on CIS Docker Benchmark v1.6.0
- Checks host configuration
- Validates Docker daemon settings
- Audits container configurations
- Reviews network settings

### 2. Vulnerable Demo Application

We've included a demo application (`demo-vulnerable-app.yml`) with intentional security issues to demonstrate what Docker Bench Security detects:

**Security Issues Included:**
- Privileged containers
- Host network mode
- Docker socket mounted
- Hardcoded credentials
- Weak passwords
- All capabilities added
- Disabled security profiles (AppArmor, Seccomp)
- Direct host filesystem mounts

## Step-by-Step Guide

### Step 1: Run Initial Audit

First, let's run Docker Bench Security to see your current security posture:

```bash
cd labs/01-docker-bench-security
./run-audit.sh
```

The audit will check:
- Host Configuration (1.x checks)
- Docker Daemon Configuration (2.x checks)
- Docker Daemon Configuration Files (3.x checks)
- Container Images and Build Files (4.x checks)
- Container Runtime (5.x checks)
- Docker Security Operations (6.x checks)
- Docker Swarm Configuration (7.x checks)

### Step 2: Deploy Vulnerable Application

Deploy the intentionally vulnerable demo application:

```bash
docker-compose -f demo-vulnerable-app.yml up -d
```

This creates containers with various security issues.

### Step 3: Run Audit Again

Run the audit again to see what issues are detected:

```bash
./run-audit.sh
```

### Step 4: Analyze Results

Review the output. You should see:

**WARN results** indicate issues that need attention:
- Privileged containers running
- Host network namespace used
- Docker socket mounted inside containers
- Containers running without security profiles
- Weak or default credentials detected

**PASS results** indicate compliant configurations.

**INFO results** provide additional context.

### Step 5: Cleanup

Remove the vulnerable application:

```bash
docker-compose -f demo-vulnerable-app.yml down
docker system prune -f
```

## Understanding the Results

### Check Categories

1. **Host Configuration (1.x)**
   - Separate partition for containers
   - Hardened kernel
   - Docker version updates

2. **Docker Daemon Configuration (2.x)**
   - Network traffic restrictions
   - Logging configuration
   - Storage drivers
   - TLS authentication

3. **Docker Daemon Files (3.x)**
   - File ownership and permissions
   - Configuration file security

4. **Container Images (4.x)**
   - Trusted registries
   - Content trust
   - Image signing
   - Minimal base images

5. **Container Runtime (5.x)**
   - AppArmor/SELinux profiles
   - Linux kernel capabilities
   - Privileged containers
   - Network namespaces
   - Resource limits

6. **Security Operations (6.x)**
   - Audit logging
   - Daemon configuration
   - Remote API security

7. **Docker Swarm (7.x)**
   - Swarm mode security
   - Secret management

## Common Issues and Fixes

### Issue: Privileged Containers

**Problem:** Container running with `privileged: true`

**Fix:**
```yaml
services:
  myapp:
    # privileged: true  # Remove this
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE  # Only add needed capabilities
```

### Issue: Host Network Mode

**Problem:** Container using `network_mode: host`

**Fix:**
```yaml
services:
  myapp:
    # network_mode: host  # Remove this
    networks:
      - app-network
    ports:
      - "8080:80"  # Use port mapping instead

networks:
  app-network:
    driver: bridge
```

### Issue: Docker Socket Mounted

**Problem:** Docker socket exposed to container

**Fix:**
Remove the socket mount and use Docker API with proper authentication if needed:
```yaml
# Remove this:
# volumes:
#   - /var/run/docker.sock:/var/run/docker.sock
```

### Issue: Hardcoded Credentials

**Problem:** Sensitive data in environment variables

**Fix:**
```yaml
services:
  db:
    image: mysql:8
    environment:
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_password
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

## Best Practices Demonstrated

1. **Principle of Least Privilege**
   - Drop unnecessary capabilities
   - Avoid privileged mode
   - Use specific user IDs

2. **Network Isolation**
   - Use custom bridge networks
   - Avoid host network mode
   - Implement network policies

3. **Resource Limits**
   - Set memory limits
   - Set CPU limits
   - Prevent resource exhaustion

4. **Security Profiles**
   - Enable AppArmor/SELinux
   - Use seccomp profiles
   - Implement mandatory access control

5. **Image Security**
   - Use minimal base images
   - Scan for vulnerabilities
   - Sign and verify images
   - Use specific tags (not `latest`)

## Next Steps

After completing this lab, you should:

1. **Review Your Infrastructure**
   - Run Docker Bench Security on your production systems
   - Document all WARN findings
   - Create remediation plan

2. **Implement Fixes**
   - Start with high-priority issues
   - Test changes in staging
   - Update Docker Compose files

3. **Automate Auditing**
   - Schedule regular audits
   - Integrate into CI/CD pipeline
   - Monitor for configuration drift

4. **Continue Learning**
   - Proceed to Lab 02: Secure Images
   - Study CIS Docker Benchmark
   - Review Docker security documentation

## Additional Resources

- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Docker Bench Security GitHub](https://github.com/docker/docker-bench-security)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [OWASP Docker Security](https://owasp.org/www-project-docker-top-10/)

## Troubleshooting

### Error: Permission Denied

If you get permission errors:
```bash
sudo ./run-audit.sh
```

### Error: Docker Not Running

Start Docker service:
```bash
sudo systemctl start docker
```

### Error: Image Pull Failed

Check your internet connection and Docker Hub access:
```bash
docker pull docker/docker-bench-security
```

## Summary

In this lab, you learned:
- ✓ How to audit Docker security configurations
- ✓ Understanding CIS Docker Benchmark checks
- ✓ Identifying common security misconfigurations
- ✓ Implementing security best practices
- ✓ Fixing vulnerable container configurations

**Key Takeaway:** Regular security auditing with Docker Bench Security helps maintain a strong security posture and ensures compliance with industry standards.

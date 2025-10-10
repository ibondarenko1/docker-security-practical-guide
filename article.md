# Docker Security: From Theory to Practice - A Complete Guide

## Introduction

Docker has revolutionized application deployment, but with great power comes great responsibility. This comprehensive guide takes you through Docker security best practices with hands-on labs you can run on any system.

**What makes this guide different:**
- 100% practical, runnable examples
- No platform dependencies
- Based on industry standards (CIS Benchmark)
- Progressive learning path
- Real-world scenarios

## Why Docker Security Matters

Containers share the host kernel, making security paramount. A single misconfigured container can:
- Expose sensitive data
- Provide root access to the host
- Enable lateral movement
- Compromise entire infrastructure

**Statistics:**
- 60% of organizations experienced container security incidents
- 80% of images contain known vulnerabilities
- 90% of breaches involve misconfiguration

## The Docker Security Model

### Defense in Depth

Docker security operates on multiple layers:

1. **Host Security**: Hardened host OS
2. **Image Security**: Minimal, scanned images
3. **Runtime Security**: Isolated execution
4. **Network Security**: Segmented communication
5. **Data Security**: Protected secrets

### CIS Docker Benchmark

The Center for Internet Security (CIS) provides a comprehensive benchmark for Docker security:

- **7 main sections**: Host, Daemon, Files, Images, Runtime, Operations, Swarm
- **100+ checks**: Automated security validation
- **Industry standard**: Widely adopted baseline

## Lab 01: Security Auditing with Docker Bench

### What You'll Learn

- Run comprehensive security audits
- Understand CIS compliance
- Identify misconfigurations
- Fix security issues

### Hands-On Exercise

**Step 1: Run Initial Audit**

```bash
cd labs/01-docker-bench-security
./run-audit.sh
```

Docker Bench Security runs 100+ checks across:
- Host configuration
- Docker daemon settings
- File permissions
- Container configurations
- Network settings

**Step 2: Deploy Vulnerable Application**

```bash
docker-compose -f demo-vulnerable-app.yml up -d
```

This creates containers with intentional security issues:
- Privileged mode enabled
- Host network namespace
- Docker socket mounted
- Hardcoded credentials
- All capabilities granted

**Step 3: Audit Again**

```bash
./run-audit.sh
```

### Understanding the Results

**Output Format:**
```
[PASS] 5.1 - Verify AppArmor profile, if applicable
[WARN] 5.2 - Verify SELinux security options, if applicable
[INFO] 5.3 - Restrict Linux Kernel Capabilities within containers
```

**Result Categories:**
- **PASS**: Compliant with benchmark
- **WARN**: Needs attention
- **INFO**: Manual review required

### Common Issues Found

**Issue 1: Privileged Containers**

**Problem:**
```yaml
privileged: true  # Full host access!
```

**Impact:**
- Bypasses all security mechanisms
- Full device access
- Can modify host kernel

**Fix:**
```yaml
# Remove privileged mode
cap_drop:
  - ALL
cap_add:
  - NET_BIND_SERVICE  # Only what's needed
security_opt:
  - no-new-privileges:true
```

**Issue 2: Host Network Mode**

**Problem:**
```yaml
network_mode: host  # Shares host network stack
```

**Impact:**
- Breaks network isolation
- Exposes all host network interfaces
- Enables network reconnaissance

**Fix:**
```yaml
# Use bridge network instead
networks:
  - app-network
ports:
  - "8080:80"  # Explicit port mapping
```

**Issue 3: Docker Socket Mounted**

**Problem:**
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock  # Full Docker access!
```

**Impact:**
- Can create privileged containers
- Can mount host filesystem
- Equivalent to root access

**Fix:**
```yaml
# Remove socket mount entirely
# If needed, use Docker API with proper authentication
# Or use alternatives like Podman socket with SELinux
```

### Key Takeaways

1. **Regular Auditing**: Run Docker Bench weekly
2. **Baseline Security**: Fix all WARN items
3. **Continuous Monitoring**: Integrate into CI/CD
4. **Documentation**: Track exceptions and waivers

## Lab 02: Building Secure Images

### The Problem with Image Security

**Common Issues:**
- Large attack surface (unnecessary packages)
- Outdated dependencies (known CVEs)
- Running as root
- Hardcoded secrets

### Multi-Stage Builds

**Before (Insecure):**
```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    python3 \
    python3-pip
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python3", "app.py"]
```

**Issues:**
- 700MB+ image size
- Build tools in production
- Running as root
- No vulnerability scanning

**After (Secure):**
```dockerfile
# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Runtime stage
FROM gcr.io/distroless/python3-debian12
COPY --from=builder /wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*
COPY --chown=nonroot:nonroot app.py .
USER nonroot
CMD ["python3", "app.py"]
```

**Improvements:**
- 50MB image (14x smaller)
- No build tools
- Distroless base (minimal attack surface)
- Non-root user
- Scannable layers

### Image Scanning

**Trivy Scan:**
```bash
trivy image myapp:latest

# Output:
# Total: 47 (CRITICAL: 12, HIGH: 35)
```

**Remediation Process:**
1. Update base image
2. Patch vulnerable packages
3. Remove unnecessary dependencies
4. Rescan until clean

## Lab 03: Least Privilege Containers

### The Principle of Least Privilege

Containers should have:
- Minimal capabilities
- Non-root user
- Read-only filesystem
- Resource limits

### Linux Capabilities

Instead of running as root, drop unnecessary capabilities:

```yaml
services:
  app:
    image: myapp:latest
    cap_drop:
      - ALL  # Drop everything
    cap_add:
      - NET_BIND_SERVICE  # Only add what's needed
      - CHOWN
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp  # Writable temp space
```

### User Namespaces

**Enable in daemon.json:**
```json
{
  "userns-remap": "default"
}
```

**Effect:**
- Container root ≠ Host root
- UID remapping
- Additional isolation layer

## Lab 04: Secrets Management

### The Secrets Problem

**Never do this:**
```yaml
environment:
  - DB_PASSWORD=supersecret123  # ❌
  - API_KEY=abc123xyz           # ❌
```

**Why it's dangerous:**
- Visible in `docker inspect`
- Logged in container history
- Exposed in orchestration configs
- Leaked in CI/CD logs

### Docker Secrets (Swarm)

```yaml
services:
  db:
    image: postgres:15
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
```

**Create secret:**
```bash
echo "secure_password" | docker secret create db_password -
```

### External Secret Management

**HashiCorp Vault Integration:**
```bash
# Get secret from Vault
vault kv get -field=password secret/db/password

# Inject into container
docker run -e DB_PASS=$(vault kv get -field=password secret/db/password) myapp
```

### Secrets Scanning

```bash
# Scan for leaked secrets
trufflehog git file://. --only-verified

# GitHub pre-commit hook
git secrets --install
git secrets --register-aws
```

## Lab 05: Network Security

### Docker Network Isolation

**Default bridge network:**
```
All containers communicate freely ❌
```

**Custom bridge networks:**
```yaml
services:
  web:
    networks:
      - frontend
  api:
    networks:
      - frontend
      - backend
  db:
    networks:
      - backend  # Isolated from web

networks:
  frontend:
  backend:
    internal: true  # No external access
```

### Network Policies

```yaml
services:
  app:
    networks:
      app-network:
        ipv4_address: 172.20.0.5
    sysctls:
      - net.ipv4.ip_forward=0  # Disable forwarding
```

### TLS Encryption

```yaml
services:
  web:
    environment:
      - TLS_ENABLED=true
    volumes:
      - ./certs:/certs:ro
    command: >
      --tls
      --tlscert=/certs/cert.pem
      --tlskey=/certs/key.pem
```

## Lab 06: Runtime Security

### Security Event Detection

**What to monitor:**
- Unexpected process execution
- Unusual network connections
- File system modifications
- Privilege escalation attempts
- System call anomalies

### Audit Logging

**Docker daemon logging:**
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3",
    "labels": "production"
  }
}
```

**Container logs to SIEM:**
```yaml
services:
  app:
    logging:
      driver: syslog
      options:
        syslog-address: "tcp://siem.example.com:514"
        tag: "{{.Name}}/{{.ID}}"
```

## Security Automation

### CI/CD Integration

**GitLab CI Example:**
```yaml
stages:
  - build
  - scan
  - deploy

security_scan:
  stage: scan
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - trivy image $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker run docker/docker-bench-security
  allow_failure: false
```

### Continuous Compliance

```bash
# Daily audit
0 2 * * * /usr/local/bin/docker-bench-security.sh > /var/log/docker-audit.log

# Alert on failures
if grep -q "WARN" /var/log/docker-audit.log; then
  send-alert "Docker security audit found issues"
fi
```

## Best Practices Checklist

### Image Security
- [ ] Use minimal base images (Alpine, Distroless)
- [ ] Scan images for vulnerabilities
- [ ] Sign images with Content Trust
- [ ] Use specific tags, never `latest`
- [ ] Multi-stage builds for smaller images
- [ ] Regular base image updates

### Container Runtime
- [ ] Run as non-root user
- [ ] Drop all capabilities, add only needed ones
- [ ] Enable security profiles (AppArmor/SELinux)
- [ ] Use read-only filesystems
- [ ] Set resource limits (CPU, memory)
- [ ] Enable no-new-privileges

### Network Security
- [ ] Custom bridge networks
- [ ] Avoid host network mode
- [ ] Network segmentation by function
- [ ] TLS for inter-service communication
- [ ] Disable inter-container connectivity when not needed
- [ ] Use internal networks for databases

### Secrets Management
- [ ] Never hardcode secrets
- [ ] Use Docker secrets or external vault
- [ ] Rotate secrets regularly
- [ ] Limit secret access scope
- [ ] Scan for leaked secrets
- [ ] Use secret files, not environment variables

### Monitoring & Compliance
- [ ] Regular security audits with Docker Bench
- [ ] Container behavior monitoring
- [ ] Centralized logging
- [ ] Security event alerting
- [ ] Incident response plan
- [ ] Keep Docker updated

## Real-World Scenarios

### Scenario 1: Legacy Application Migration

**Challenge:**
Migrating a legacy PHP application running as root on bare metal.

**Solution:**
```dockerfile
FROM php:8.2-fpm-alpine

# Create non-root user
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

# Install only required extensions
RUN docker-php-ext-install pdo pdo_mysql

# Copy application
COPY --chown=appuser:appuser . /var/www/html

# Switch to non-root
USER appuser

EXPOSE 9000
CMD ["php-fpm"]
```

**Security improvements:**
- Non-root execution
- Minimal Alpine base
- Only required extensions
- Proper file ownership

### Scenario 2: Microservices Architecture

**Challenge:**
Securing communication between 10+ microservices.

**Solution:**
```yaml
services:
  frontend:
    networks:
      - public
      - frontend-backend
    
  api-gateway:
    networks:
      - frontend-backend
      - backend
    
  user-service:
    networks:
      - backend
      - database
    
  payment-service:
    networks:
      - backend
      - database
      - payment-external
    
  database:
    networks:
      - database
    deploy:
      resources:
        limits:
          memory: 2G

networks:
  public:
  frontend-backend:
  backend:
    internal: true
  database:
    internal: true
  payment-external:
```

**Benefits:**
- Layered network isolation
- Database completely internal
- External access only where needed
- Resource limits prevent DoS

### Scenario 3: CI/CD Pipeline Hardening

**Challenge:**
Securing the build and deployment pipeline.

**Solution:**
```yaml
# .gitlab-ci.yml
variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

before_script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

build:
  stage: build
  script:
    - docker build --no-cache -t $IMAGE_TAG .
    - docker push $IMAGE_TAG
  only:
    - main

security_scan:
  stage: test
  script:
    # Vulnerability scan
    - trivy image --severity HIGH,CRITICAL $IMAGE_TAG
    
    # Secret scan
    - trufflehog filesystem . --fail
    
    # CIS benchmark
    - docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
        docker/docker-bench-security
    
    # Dockerfile lint
    - hadolint Dockerfile
  allow_failure: false

sign_image:
  stage: sign
  script:
    - export DOCKER_CONTENT_TRUST=1
    - docker push $IMAGE_TAG
  only:
    - main

deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/
  environment:
    name: production
  only:
    - main
  when: manual
```

## Advanced Topics

### 1. Security Profiles

**AppArmor Profile:**
```
#include <tunables/global>

profile docker-nginx flags=(attach_disconnected,mediate_deleted) {
  #include <abstractions/base>
  
  network inet tcp,
  network inet udp,
  
  /usr/sbin/nginx mr,
  /var/log/nginx/* w,
  /var/www/html/** r,
  
  deny /proc/sys/kernel/** wl,
  deny /sys/** wl,
}
```

**Apply to container:**
```yaml
services:
  web:
    security_opt:
      - apparmor=docker-nginx
```

### 2. Seccomp Profiles

**Custom Seccomp:**
```json
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {
      "names": ["read", "write", "open", "close", "stat"],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
```

**Apply:**
```bash
docker run --security-opt seccomp=profile.json myapp
```

### 3. Image Signing with Cosign

```bash
# Generate keys
cosign generate-key-pair

# Sign image
cosign sign --key cosign.key myregistry/myapp:v1.0

# Verify
cosign verify --key cosign.pub myregistry/myapp:v1.0
```

## Compliance and Regulations

### GDPR Compliance
- Data encryption at rest and in transit
- Audit logging of data access
- Right to be forgotten (data deletion)
- Secrets management for PII

### PCI DSS Requirements
- Network segmentation
- Access control and authentication
- Regular security testing
- Vulnerability management

### SOC 2 Controls
- Change management
- Incident response
- Continuous monitoring
- Access reviews

## Incident Response

### Detection

**Indicators of Compromise:**
- Unexpected outbound connections
- New processes not in base image
- File system modifications
- Unusual resource consumption
- Failed authentication attempts

### Response Steps

1. **Isolate**: Disconnect compromised container
```bash
docker network disconnect bridge compromised-container
```

2. **Preserve**: Save container state for forensics
```bash
docker commit compromised-container forensics-image
docker save forensics-image > evidence.tar
```

3. **Investigate**: Analyze container
```bash
docker export compromised-container | tar t
docker diff compromised-container
docker logs compromised-container
```

4. **Remediate**: Remove and rebuild
```bash
docker stop compromised-container
docker rm compromised-container
docker rmi vulnerable-image
```

5. **Harden**: Update and redeploy
```bash
# Fix vulnerability
# Update image
# Scan again
# Deploy fixed version
```

## Performance vs Security Trade-offs

### User Namespaces
**Security**: ⭐⭐⭐⭐⭐
**Performance**: ⭐⭐⭐⭐ (Minor UID mapping overhead)

### Read-only Filesystems
**Security**: ⭐⭐⭐⭐⭐
**Performance**: ⭐⭐⭐⭐⭐ (No impact)

### Security Scanning
**Security**: ⭐⭐⭐⭐⭐
**Performance**: ⭐⭐⭐ (Build time increase)

### AppArmor/SELinux
**Security**: ⭐⭐⭐⭐⭐
**Performance**: ⭐⭐⭐⭐ (Negligible overhead)

## Common Pitfalls

### 1. "It works locally, ship it!"
**Problem**: No security testing before deployment

**Solution**: Automated security gates in CI/CD

### 2. "We'll fix security later"
**Problem**: Technical debt accumulation

**Solution**: Security from the start, shift-left approach

### 3. "One privileged container won't hurt"
**Problem**: Exception becomes the rule

**Solution**: Document all exceptions, require approval

### 4. "Scanning slows us down"
**Problem**: Skipping vulnerability scans

**Solution**: Parallel scanning, fail fast on critical CVEs

### 5. "No one will attack us"
**Problem**: Complacency

**Solution**: Regular threat modeling, penetration testing

## Conclusion

Docker security is not a one-time task but a continuous process:

1. **Build Secure**: Start with minimal, scanned images
2. **Deploy Securely**: Use least privilege and isolation
3. **Monitor Actively**: Detect and respond to threats
4. **Audit Regularly**: Maintain compliance
5. **Improve Continuously**: Learn from incidents

### Next Steps

1. Complete all six labs in order
2. Audit your current Docker deployments
3. Create a remediation roadmap
4. Implement CI/CD security gates
5. Schedule regular security reviews

### Resources

- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Docker Security Documentation](https://docs.docker.com/engine/security/)
- [NIST Container Security Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-190.pdf)
- [OWASP Docker Security](https://owasp.org/www-project-docker-top-10/)

### Community

- GitHub: [docker-security-practical-guide](https://github.com/opscart/docker-security-practical-guide)
- Discussions: Open issues for questions
- Contributions: PRs welcome!

---

**Remember**: Security is a journey, not a destination. Stay vigilant, keep learning, and continuously improve your security posture.

**🔒 Happy securing! 🚀**

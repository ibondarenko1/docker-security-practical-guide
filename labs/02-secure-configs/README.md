# Lab 02: Secure Container Configurations

## Objectives

- Compare insecure vs. secure container configurations
- Understand Linux capabilities
- Implement read-only filesystems
- Apply security options

## Lab Steps

### 1. Deploy Insecure Container

```bash
./deploy-insecure.sh
```

### 2. Deploy Secure Container

```bash
./deploy-secure.sh
```

### 3. Compare Security Postures

```bash
./compare-security.sh
```

### 4. Test Security Controls

```bash
./test-security.sh
```

## Key Learnings

- Capability dropping reduces attack surface
- Read-only filesystems prevent tampering
- User namespace remapping improves isolation
- Security options enforce additional policies

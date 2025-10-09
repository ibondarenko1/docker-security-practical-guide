# Lab 01: Falco Runtime Detection

## Objectives

- Deploy Falco for runtime security monitoring
- Detect suspicious container behavior
- Create custom detection rules
- Analyze security events

## Prerequisites

- Docker installed
- Root/sudo access
- Linux kernel 4.14+

## Lab Steps

### 1. Start Falco

```bash
./deploy-falco.sh
```

### 2. Run Attack Scenarios

```bash
./attack-scenarios.sh
```

### 3. Analyze Alerts

```bash
docker logs -f falco
```

## Expected Outcomes

You should see Falco alerts for:
- Sensitive file access
- Suspicious network activity
- Privilege escalation attempts
- Container escape attempts

## Cleanup

```bash
./cleanup.sh
```

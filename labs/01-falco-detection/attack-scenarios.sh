#!/bin/bash

echo "Running attack scenarios..."

# Scenario 1: Reading sensitive files
echo -e "\n=== Scenario 1: Sensitive File Access ==="
docker run --rm alpine cat /etc/shadow 2>/dev/null || echo "Blocked as expected"

# Scenario 2: Network scanning
echo -e "\n=== Scenario 2: Network Scanning ==="
docker run --rm alpine sh -c "nc -zv 172.17.0.1 1-100 2>&1 | head -5"

# Scenario 3: Privilege escalation attempt
echo -e "\n=== Scenario 3: Privilege Escalation ==="
docker run --rm alpine sh -c "chmod +s /bin/sh 2>/dev/null || echo 'Cannot escalate'"

# Scenario 4: Executing from /tmp
echo -e "\n=== Scenario 4: Execute from /tmp ==="
docker run --rm alpine sh -c "cp /bin/sh /tmp/malicious && /tmp/malicious -c 'echo Executed'"

echo -e "\n=== Check Falco logs for alerts ==="
echo "Run: docker logs falco | tail -20"

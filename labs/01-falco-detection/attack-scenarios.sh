#!/bin/bash

OS=$(uname -s)

if [ "$OS" != "Linux" ]; then
    echo "⚠️  This lab requires Linux"
    echo "Skip to Lab 02: cd ../02-secure-configs"
    exit 0
fi

echo "Running attack scenarios..."

echo -e "\n=== Scenario 1: Sensitive File Access ==="
docker run --rm alpine cat /etc/shadow 2>/dev/null || echo "Blocked"

echo -e "\n=== Scenario 2: Network Scanning ==="
docker run --rm alpine sh -c "nc -zv 172.17.0.1 1-100 2>&1 | head -5"

echo -e "\n=== Scenario 3: Privilege Escalation ==="
docker run --rm alpine sh -c "chmod +s /bin/sh 2>/dev/null || echo 'Cannot escalate'"

echo -e "\n=== Scenario 4: Execute from /tmp ==="
docker run --rm alpine sh -c "cp /bin/sh /tmp/malicious && /tmp/malicious -c 'echo Executed'"

echo -e "\n=== Check Falco logs for alerts ==="
echo "Run: docker logs falco | tail -20"

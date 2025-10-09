#!/bin/bash

echo "=== Testing Security Controls ==="

echo -e "\n1. Testing package installation (should fail on secure):"
echo "Insecure container:"
docker exec insecure-nginx sh -c "apt-get update >/dev/null 2>&1 && echo 'SUCCESS: Can install packages'" || echo "FAILED"

echo "Secure container:"
docker exec secure-nginx sh -c "apt-get update >/dev/null 2>&1 && echo 'SUCCESS: Can install packages'" || echo "FAILED (as expected)"

echo -e "\n2. Testing file creation in root (should fail on secure):"
echo "Insecure container:"
docker exec insecure-nginx sh -c "touch /test.txt && echo 'SUCCESS: Can write to /' || echo 'FAILED'"

echo "Secure container:"
docker exec secure-nginx sh -c "touch /test.txt && echo 'SUCCESS: Can write to /' || echo 'FAILED (as expected)'"

echo -e "\n3. Testing privilege escalation (should fail on both with no-new-privileges):"
docker exec secure-nginx sh -c "cat /proc/self/status | grep NoNewPrivs"

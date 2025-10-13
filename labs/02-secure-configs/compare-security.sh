#!/bin/bash

echo "=== Security Comparison ==="
echo ""

echo "INSECURE Container Capabilities:"
docker exec insecure-nginx grep '^Cap' /proc/1/status

echo ""
echo "SECURE Container Capabilities:"
docker exec secure-nginx grep '^Cap' /proc/1/status

echo ""
echo "INSECURE Container User:"
docker exec insecure-nginx whoami

echo ""
echo "SECURE Container User:"
docker exec secure-nginx whoami

echo ""
echo "INSECURE Container Processes:"
docker exec insecure-nginx ps aux 2>/dev/null || echo "ps command not available"

echo ""
echo "SECURE Container Processes:"
docker exec secure-nginx ps aux | head -5

echo ""
echo "=== Filesystem Test ==="
echo "INSECURE Container - Try writing to /:"
docker exec insecure-nginx sh -c "touch /test.txt && echo 'SUCCESS: Can write to /' || echo 'FAILED'"

echo ""
echo "SECURE Container - Try writing to /:"
docker exec secure-nginx sh -c "touch /test.txt && echo 'SUCCESS: Can write to /' || echo 'FAILED: Read-only filesystem'"
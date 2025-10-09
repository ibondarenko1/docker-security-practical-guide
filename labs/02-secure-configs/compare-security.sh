#!/bin/bash

echo "=== Security Comparison ==="
echo ""

echo "INSECURE Container Capabilities:"
docker exec insecure-nginx capsh --print | grep "Current:"

echo ""
echo "SECURE Container Capabilities:"
docker exec secure-nginx capsh --print | grep "Current:"

echo ""
echo "INSECURE Container User:"
docker exec insecure-nginx whoami

echo ""
echo "SECURE Container User:"
docker exec secure-nginx whoami

echo ""
echo "INSECURE Container Processes:"
docker exec insecure-nginx ps aux | head -5

echo ""
echo "SECURE Container Processes:"
docker exec secure-nginx ps aux | head -5

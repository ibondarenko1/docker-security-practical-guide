#!/bin/bash

echo "Running Docker Security Audit..."
echo ""

# Check Docker daemon configuration
echo "=== Docker Daemon Security ==="
docker info --format '{{json .SecurityOptions}}' | jq .

# List running containers with security concerns
echo ""
echo "=== Potentially Insecure Containers ==="
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" --filter "status=running"

for container in $(docker ps -q); do
    name=$(docker inspect --format '{{.Name}}' $container | sed 's/\///')
    privileged=$(docker inspect --format '{{.HostConfig.Privileged}}' $container)
    caps=$(docker inspect --format '{{json .HostConfig.CapAdd}}' $container)
    
    if [ "$privileged" = "true" ]; then
        echo "⚠️  $name is running in privileged mode"
    fi
    
    if [ "$caps" != "null" ]; then
        echo "⚠️  $name has added capabilities: $caps"
    fi
done

echo ""
echo "=== Image Vulnerabilities (Top 5 Critical) ==="
for image in $(docker images --format "{{.Repository}}:{{.Tag}}" | head -5); do
    echo "Scanning: $image"
    trivy image --severity CRITICAL --quiet $image | head -10
    echo ""
done

echo "Audit complete!"

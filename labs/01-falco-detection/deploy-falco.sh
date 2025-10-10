#!/bin/bash

echo "Deploying Falco runtime security monitoring..."

# Detect OS
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    echo ""
    echo "⚠️  macOS Detected - Lab 01 Not Supported"
    echo ""
    echo "Falco requires direct kernel access which Docker Desktop on macOS cannot provide."
    echo ""
    echo "Options:"
    echo "  1. Skip this lab - Labs 2-6 work perfectly on macOS"
    echo "  2. Use a Linux VM (UTM, Parallels, VirtualBox)"
    echo "  3. Use a cloud Linux instance"
    echo "  4. Use Colima instead of Docker Desktop"
    echo ""
    echo "Recommended: Skip to Lab 02"
    echo "  cd ../02-secure-configs"
    echo "  ./deploy-secure.sh"
    echo ""
    exit 0
fi

# Linux deployment
echo "✓ Linux detected - proceeding with full Falco deployment"

# Stop existing
docker stop falco 2>/dev/null
docker rm falco 2>/dev/null

docker run -d \
  --name falco \
  --privileged \
  -v /var/run/docker.sock:/host/var/run/docker.sock \
  -v /dev:/host/dev \
  -v /proc:/host/proc:ro \
  -v /boot:/host/boot:ro \
  -v /lib/modules:/host/lib/modules:ro \
  -v /usr:/host/usr:ro \
  -v $(pwd)/custom-rules.yaml:/etc/falco/rules.d/custom-rules.yaml \
  falcosecurity/falco:0.37.0

echo "Waiting for Falco to initialize..."
sleep 10

if docker ps | grep -q falco; then
    echo ""
    echo "✅ Falco deployed successfully!"
    echo ""
    echo "View logs: docker logs -f falco"
    echo "Run attacks: ./attack-scenarios.sh"
else
    echo ""
    echo "❌ Falco failed to start"
    docker logs falco | tail -20
    exit 1
fi

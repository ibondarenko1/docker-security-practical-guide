#!/bin/bash

echo "Setting up image signing with Cosign..."

# Check if cosign is installed and working
if ! command -v cosign &>/dev/null; then
    echo "✗ Cosign not found"
    echo "Install: brew install cosign"
    exit 1
fi

if ! cosign version &>/dev/null; then
    echo "✗ Cosign binary incompatible"
    exit 1
fi

echo "✓ Cosign: $(cosign version 2>&1 | head -1)"

# Generate key pair
if [ ! -f cosign.key ]; then
  echo ""
  echo "Generating key pair (enter a password)..."
  cosign generate-key-pair
  echo "✓ Keys generated"
else
  echo "✓ Keys exist"
fi

# Clean up
docker stop registry 2>/dev/null
docker rm registry 2>/dev/null

# Use port 5001 to avoid conflicts
echo ""
echo "Starting registry on port 5001..."
docker run -d -p 5001:5000 --restart=always --name registry registry:2

sleep 3

if docker ps | grep -q registry; then
    echo "✓ Registry on localhost:5001"
    echo ""
    echo "✅ Setup complete!"
else
    echo "✗ Failed"
    docker logs registry
    exit 1
fi

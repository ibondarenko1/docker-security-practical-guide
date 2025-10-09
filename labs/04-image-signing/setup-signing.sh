#!/bin/bash

echo "Setting up image signing with Cosign..."

# Generate key pair
if [ ! -f cosign.key ]; then
  echo "Generating cosign key pair..."
  cosign generate-key-pair
  echo "Keys generated: cosign.key (private) and cosign.pub (public)"
else
  echo "Keys already exist"
fi

# Start local registry
docker run -d -p 5000:5000 --name registry registry:2

echo "Local registry started on localhost:5000"
echo "Setup complete!"

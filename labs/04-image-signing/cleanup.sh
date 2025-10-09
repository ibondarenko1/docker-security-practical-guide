#!/bin/bash

echo "Cleaning up..."
docker stop registry 2>/dev/null
docker rm registry 2>/dev/null
docker rmi localhost:5000/signed-app:v1.0 2>/dev/null
docker rmi localhost:5000/unsigned-app:v1.0 2>/dev/null
rm -f Dockerfile admission-policy.yaml
echo "Cleanup complete!"
echo "Note: cosign.key and cosign.pub preserved for future use"

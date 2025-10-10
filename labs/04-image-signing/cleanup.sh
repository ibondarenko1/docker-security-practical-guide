#!/bin/bash

echo "Cleaning up..."
docker stop registry 2>/dev/null
docker rm registry 2>/dev/null
docker rmi localhost:5001/signed-app:v1.0 2>/dev/null
rm -f Dockerfile
echo "✓ Done (keys preserved)"

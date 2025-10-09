#!/bin/bash

echo "Cleaning up all lab resources..."

# Stop and remove all lab containers
docker ps -a --filter "name=falco" --filter "name=nginx" --filter "name=registry" \
  --filter "name=ml-inference" --format "{{.Names}}" | xargs -r docker stop
docker ps -a --filter "name=falco" --filter "name=nginx" --filter "name=registry" \
  --filter "name=ml-inference" --format "{{.Names}}" | xargs -r docker rm

# Remove lab images
docker images --filter "reference=vulnerable-app" --filter "reference=ml-inference" \
  --filter "reference=localhost:5000/*" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi

echo "✓ All lab resources cleaned up"

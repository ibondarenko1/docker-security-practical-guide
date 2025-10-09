#!/bin/bash

echo "Deploying INSECURE container (for comparison only)..."

docker run -d --name insecure-nginx \
  --privileged \
  -p 8080:80 \
  nginx:latest

echo "Insecure container deployed on port 8080"
echo "This container has ALL capabilities and runs as root!"

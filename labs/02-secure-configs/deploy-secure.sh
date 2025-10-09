#!/bin/bash

echo "Deploying SECURE container with hardening..."

docker run -d --name secure-nginx \
  --read-only \
  --tmpfs /var/run:rw,noexec,nosuid \
  --tmpfs /var/cache/nginx:rw,noexec,nosuid \
  --tmpfs /tmp:rw,noexec,nosuid \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --cap-add=CHOWN \
  --cap-add=SETUID \
  --cap-add=SETGID \
  --security-opt=no-new-privileges:true \
  --user=101:101 \
  -p 8081:80 \
  nginx:latest

echo "Secure container deployed on port 8081"
echo "This container has minimal capabilities and runs as non-root!"

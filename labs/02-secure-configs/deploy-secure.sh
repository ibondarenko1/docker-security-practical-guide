#!/bin/bash

echo "Deploying SECURE container with hardening..."
docker stop secure-nginx 2>/dev/null
docker rm secure-nginx 2>/dev/null

docker run -d --name secure-nginx \
  --read-only \
  --tmpfs /var/run:rw,noexec,nosuid,size=5m \
  --tmpfs /var/cache/nginx:rw,noexec,nosuid,size=10m \
  --tmpfs /var/cache/nginx/client_temp:rw,noexec,nosuid,size=5m \
  --tmpfs /var/cache/nginx/proxy_temp:rw,noexec,nosuid,size=5m \
  --tmpfs /var/cache/nginx/fastcgi_temp:rw,noexec,nosuid,size=5m \
  --tmpfs /var/cache/nginx/uwsgi_temp:rw,noexec,nosuid,size=5m \
  --tmpfs /var/cache/nginx/scgi_temp:rw,noexec,nosuid,size=5m \
  --tmpfs /tmp:rw,noexec,nosuid,size=5m \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  --cap-add=CHOWN \
  --cap-add=SETUID \
  --cap-add=SETGID \
  --security-opt=no-new-privileges:true \
  -p 8081:80 \
  nginx:alpine

if [ $? -eq 0 ]; then
    echo "✓ Secure container deployed on port 8081"
    echo "✓ Read-only, minimal capabilities, tmpfs for required writes"
    echo ""
    echo "Test: curl http://localhost:8081"
else
    echo "✗ Deployment failed"
    exit 1
fi

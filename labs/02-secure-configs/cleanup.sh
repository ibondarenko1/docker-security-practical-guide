#!/bin/bash

echo "Cleaning up Lab 02 containers..."

docker stop insecure-nginx secure-nginx 2>/dev/null
docker rm insecure-nginx secure-nginx 2>/dev/null

# Clean up temp files
rm -rf /tmp/nginx-secure 2>/dev/null

echo "Cleanup complete!"
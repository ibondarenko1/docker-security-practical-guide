#!/bin/bash

echo "Cleaning up containers..."
docker stop insecure-nginx secure-nginx 2>/dev/null
docker rm insecure-nginx secure-nginx 2>/dev/null
echo "Cleanup complete!"

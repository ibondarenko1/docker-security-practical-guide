#!/bin/bash

echo "Cleaning up..."
docker stop nginx-secure 2>/dev/null
docker rm nginx-secure 2>/dev/null
echo "Cleanup complete!"

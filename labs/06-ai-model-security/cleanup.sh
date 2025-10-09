#!/bin/bash

echo "Cleaning up ML inference lab..."
docker stop ml-inference 2>/dev/null
docker rm ml-inference 2>/dev/null
rm -f inference.py Dockerfile.ml requirements.txt
echo "Cleanup complete!"

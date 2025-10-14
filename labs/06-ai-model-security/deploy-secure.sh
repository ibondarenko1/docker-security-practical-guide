#!/bin/bash

echo "Deploying ML inference with security hardening..."

docker run -d \
  --name ml-inference \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=2g \
  --memory="4g" \
  --memory-swap="4g" \
  --cpus="2" \
  --pids-limit="100" \
  --security-opt=no-new-privileges:true \
  --cap-drop=ALL \
  --user=mluser \
  -p 5001:5000 \
  -e MODEL_NAME="secure-bert-classifier" \
  ml-inference:secure

echo "Waiting for service to start..."
sleep 5

echo "Testing health endpoint..."
curl -s http://localhost:5001/health | jq .

echo ""
echo "ML inference service deployed on port 5001"
echo "Test with: curl -X POST http://localhost:5001/predict -H 'Content-Type: application/json' -d '{\"text\":\"sample\"}'"

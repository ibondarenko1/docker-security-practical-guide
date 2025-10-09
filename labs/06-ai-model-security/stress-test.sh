#!/bin/bash

echo "Running stress tests on ML inference service..."

echo ""
echo "1. Normal request (should succeed):"
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"text":"This is a normal request for sentiment analysis"}' | jq .

echo ""
echo "2. Large input test (should be rejected):"
LARGE_TEXT=$(python3 -c "print('a' * 20000)")
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d "{\"text\":\"$LARGE_TEXT\"}" 2>/dev/null | jq .

echo ""
echo "3. Concurrent requests test:"
for i in {1..10}; do
  curl -X POST http://localhost:5000/predict \
    -H "Content-Type: application/json" \
    -d '{"text":"concurrent request '$i'"}' &
done
wait

echo ""
echo "4. Memory usage check:"
docker stats ml-inference --no-stream

echo ""
echo "Stress test complete!"

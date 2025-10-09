#!/bin/bash

echo "Monitoring ML inference container resources..."
echo "Press Ctrl+C to stop"
echo ""

docker stats ml-inference

#!/bin/bash

echo "Cleaning up..."

# Remove results file
rm -f bench-results.txt

# Remove any stopped bench containers
docker rm $(docker ps -a -q -f label=docker_bench_security) 2>/dev/null || true

echo "✓ Cleanup complete"

#!/bin/bash

echo "Re-running audit with detailed output..."
echo ""

docker run --rm \
  --net host \
  --pid host \
  --userns host \
  --cap-add audit_control \
  -v /etc:/etc:ro \
  -v /usr/bin/containerd:/usr/bin/containerd:ro \
  -v /usr/bin/runc:/usr/bin/runc:ro \
  -v /usr/lib/systemd:/usr/lib/systemd:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --label docker_bench_security \
  docker/docker-bench-security | tee bench-results.txt

echo ""
echo "Results saved to: bench-results.txt"
echo ""
echo "Filter by type:"
echo "  grep '\[PASS\]' bench-results.txt | wc -l  # Count passing checks"
echo "  grep '\[WARN\]' bench-results.txt          # Show warnings"
echo "  grep '\[INFO\]' bench-results.txt          # Show info items"

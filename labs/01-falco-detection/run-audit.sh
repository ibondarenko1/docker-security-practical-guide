#!/bin/bash

echo "Running Docker Bench Security Audit..."
echo ""
echo "This checks your Docker installation against CIS benchmarks"
echo ""

# Run Docker Bench Security
docker run --rm \
  --net host \
  --pid host \
  --userns host \
  --cap-add audit_control \
  -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
  -v /etc:/etc:ro \
  -v /usr/bin/containerd:/usr/bin/containerd:ro \
  -v /usr/bin/runc:/usr/bin/runc:ro \
  -v /usr/lib/systemd:/usr/lib/systemd:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --label docker_bench_security \
  docker/docker-bench-security

echo ""
echo "✅ Audit complete!"
echo ""
echo "Summary shown above. Key sections:"
echo "  [PASS] - Secure configurations"
echo "  [WARN] - Needs attention"
echo "  [INFO] - Manual verification"
echo ""
echo "To see fixes: ./show-fixes.sh"

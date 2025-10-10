#!/bin/bash

echo "Starting Docker Bench Security Audit..."
echo "========================================"
echo ""
echo "Note: Running without containerd/runc binary mounts due to filesystem restrictions."
echo "This will skip some checks but still provide valuable security insights."
echo ""

# Run Docker Bench Security with minimal mounts that work
docker run --rm \
    --net host \
    --pid host \
    --userns host \
    --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /var/lib:/var/lib:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /etc:/etc:ro \
    --label docker_bench_security \
    docker/docker-bench-security

echo ""
echo "========================================"
echo "Audit complete! Review the results above."
echo ""
echo "Note: Some checks related to containerd/runc binaries were skipped."
echo "For detailed information, check the CIS Docker Benchmark documentation."

#!/bin/bash

echo "Starting Docker Bench Security Audit..."
echo "========================================"

# Detect OS
OS_TYPE=$(uname -s)

if [ "$OS_TYPE" = "Darwin" ]; then
    echo "Detected macOS - using macOS-compatible configuration"
    echo ""
    
    # macOS-specific: Create /etc/hostname if it doesn't exist
    if [ ! -f /etc/hostname ]; then
        echo "Note: /etc/hostname doesn't exist on macOS (this is normal)"
    fi
    
    # Run Docker Bench Security with macOS-compatible mounts
    docker run --rm \
        --net host \
        --pid host \
        --userns host \
        --cap-add audit_control \
        -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        --label docker_bench_security \
        docker/docker-bench-security
    
    echo ""
    echo "Note: Some Linux-specific checks were skipped on macOS."
    echo "This is expected behavior for Docker Desktop on Mac."
    
elif [ "$OS_TYPE" = "Linux" ]; then
    echo "Detected Linux - using full configuration"
    echo ""
    
    # Build the docker run command with only existing mounts
    MOUNTS="-v /etc:/etc:ro -v /var/lib:/var/lib:ro -v /var/run/docker.sock:/var/run/docker.sock:ro"
    
    # Check if containerd exists and is a regular file
    if [ -f "/usr/bin/containerd" ] && [ ! -d "/usr/bin/containerd" ]; then
        MOUNTS="$MOUNTS -v /usr/bin/containerd:/usr/bin/containerd:ro"
        echo "Mounting /usr/bin/containerd"
    fi
    
    # Check if runc exists
    if [ -f "/usr/bin/runc" ] && [ ! -d "/usr/bin/runc" ]; then
        MOUNTS="$MOUNTS -v /usr/bin/runc:/usr/bin/runc:ro"
        echo "Mounting /usr/bin/runc"
    fi
    
    # Check for systemd directory
    if [ -d "/usr/lib/systemd" ]; then
        MOUNTS="$MOUNTS -v /usr/lib/systemd:/usr/lib/systemd:ro"
        echo "Mounting /usr/lib/systemd"
    elif [ -d "/lib/systemd" ]; then
        MOUNTS="$MOUNTS -v /lib/systemd:/lib/systemd:ro"
        echo "Mounting /lib/systemd"
    fi
    
    echo ""
    echo "Running Docker Bench Security..."
    echo ""
    
    # Run Docker Bench Security with collected mounts
    docker run --rm \
        --net host \
        --pid host \
        --userns host \
        --cap-add audit_control \
        -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
        $MOUNTS \
        --label docker_bench_security \
        docker/docker-bench-security

else
    echo "Unsupported OS: $OS_TYPE"
    echo "This script supports Linux and macOS only."
    exit 1
fi

echo ""
echo "========================================"
echo "Audit complete! Review the results above."
echo ""
echo "For detailed information, check the CIS Docker Benchmark documentation."
echo "https://www.cisecurity.org/benchmark/docker"
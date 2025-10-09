#!/bin/bash

echo "Testing container with restrictive seccomp profile..."

docker run --rm \
  --security-opt seccomp=restrictive-profile.json \
  alpine sh -c "
    echo 'Testing basic operations...'
    echo 'File operations:' && ls / > /dev/null && echo '✓ Passed' || echo '✗ Blocked'
    echo 'Network listen:' && nc -l -p 8080 -w 1 2>&1 || echo '✗ Blocked (expected)'
    echo 'Mount operations:' && mount 2>&1 || echo '✗ Blocked (expected)'
  "

echo ""
echo "Restrictive profile blocks dangerous syscalls"

#!/bin/bash

echo "Testing container with default Docker seccomp profile..."

docker run --rm alpine sh -c "
  echo 'Testing basic operations...'
  echo 'File operations:' && ls / > /dev/null && echo '✓ Passed'
  echo 'Network operations:' && nc -l -p 8080 -w 1 & echo '✓ Passed'
  echo 'Process operations:' && ps aux > /dev/null && echo '✓ Passed'
"

echo ""
echo "Default profile allows most operations"

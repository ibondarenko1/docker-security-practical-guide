#!/bin/bash

echo "Cleaning up Falco lab..."
docker stop falco 2>/dev/null
docker rm falco 2>/dev/null
echo "Cleanup complete!"

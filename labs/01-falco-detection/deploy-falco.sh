#!/bin/bash

echo "Deploying Falco runtime security monitoring..."

docker run -d \
  --name falco \
  --privileged \
  -v /var/run/docker.sock:/host/var/run/docker.sock \
  -v /dev:/host/dev \
  -v /proc:/host/proc:ro \
  -v /boot:/host/boot:ro \
  -v /lib/modules:/host/lib/modules:ro \
  -v /usr:/host/usr:ro \
  -v $(pwd)/custom-rules.yaml:/etc/falco/rules.d/custom-rules.yaml \
  falcosecurity/falco:0.37.0

echo "Waiting for Falco to initialize..."
sleep 10

echo "Falco deployed successfully!"
echo "View logs with: docker logs -f falco"

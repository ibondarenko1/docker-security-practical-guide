#!/bin/bash

echo "Testing signature enforcement..."

echo ""
echo "1. Pulling signed image (should succeed):"
cosign verify --key cosign.pub localhost:5000/signed-app:v1.0 && \
  docker pull localhost:5000/signed-app:v1.0

echo ""
echo "2. Attempting to pull unsigned image (should fail with verification):"
docker build -t localhost:5000/unsigned-app:v1.0 -f Dockerfile .
docker push localhost:5000/unsigned-app:v1.0
cosign verify --key cosign.pub localhost:5000/unsigned-app:v1.0 || \
  echo "Verification failed (expected - image not signed)"

echo ""
echo "3. Creating admission policy for Kubernetes (example):"
cat > admission-policy.yaml << 'POLICY'
apiVersion: v1
kind: ConfigMap
metadata:
  name: cosign-policy
data:
  policy.yaml: |
    apiVersion: policy.sigstore.dev/v1beta1
    kind: ClusterImagePolicy
    metadata:
      name: signed-images-policy
    spec:
      images:
      - glob: "**"
      authorities:
      - key:
          data: |
            $(cat cosign.pub)
POLICY

echo "Admission policy created: admission-policy.yaml"

#!/bin/bash

echo "Building and signing image..."

# Build sample image
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:latest
RUN echo "Signed Image - Lab 04" > /app.txt
CMD ["cat", "/app.txt"]
DOCKERFILE

docker build -t localhost:5000/signed-app:v1.0 .
docker push localhost:5000/signed-app:v1.0

echo "Signing image with cosign..."
cosign sign --key cosign.key localhost:5000/signed-app:v1.0

echo "Image signed successfully!"
echo "Signature stored in registry"

#!/bin/bash

echo "Verifying signature..."

if [ ! -f cosign.pub ]; then
    echo "✗ Public key not found"
    exit 1
fi

cosign verify --key cosign.pub localhost:5001/signed-app:v1.0

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Signature VALID"
else
    echo "✗ Signature INVALID"
    exit 1
fi

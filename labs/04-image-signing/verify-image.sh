#!/bin/bash

echo "Verifying image signature..."

cosign verify --key cosign.pub localhost:5000/signed-app:v1.0

echo ""
echo "Verification complete!"
echo "If you see 'Verification for localhost:5000/signed-app:v1.0 -- VALID', the signature is correct"

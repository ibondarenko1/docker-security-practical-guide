#!/bin/bash

echo "Setting up Docker Security Lab environment..."

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed"
    exit 1
fi

echo "✓ Docker found: $(docker --version)"

# Install Trivy
if ! command -v trivy &> /dev/null; then
    echo "Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
else
    echo "✓ Trivy already installed: $(trivy --version)"
fi

# Install Cosign
if ! command -v cosign &> /dev/null; then
    echo "Installing Cosign..."
    COSIGN_VERSION=v2.2.0
    curl -sLO https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64
    chmod +x cosign-linux-amd64
    sudo mv cosign-linux-amd64 /usr/local/bin/cosign
else
    echo "✓ Cosign already installed: $(cosign version)"
fi

# Install Syft
if ! command -v syft &> /dev/null; then
    echo "Installing Syft..."
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
else
    echo "✓ Syft already installed: $(syft version)"
fi

# Install Grype
if ! command -v grype &> /dev/null; then
    echo "Installing Grype..."
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
else
    echo "✓ Grype already installed: $(grype version)"
fi

# Install jq if not present
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    fi
else
    echo "✓ jq already installed"
fi

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Navigate to any lab directory: cd labs/01-falco-detection"
echo "2. Read the README.md"
echo "3. Run the lab scripts"

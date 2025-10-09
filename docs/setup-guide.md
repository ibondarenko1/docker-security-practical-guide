# Setup Guide

## System Requirements

- **OS**: Linux, macOS, or Windows WSL2
- **Docker**: 24.0 or later
- **RAM**: 8GB minimum (16GB recommended)
- **Disk**: 20GB free space
- **CPU**: 2+ cores recommended

## Installation Steps

### 1. Install Docker

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# macOS
brew install --cask docker

# Verify installation
docker --version
```

### 2. Install Security Tools

Run the provided setup script:

```bash
./tools/setup-environment.sh
```

Or install manually:

```bash
# Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Cosign
COSIGN_VERSION=v2.2.0
curl -sLO https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign

# Syft
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
```

### 3. Verify Setup

```bash
docker info
trivy --version
cosign version
syft version
```

## Lab-Specific Setup

Each lab may require additional setup. Check the README.md in each lab directory.

## Troubleshooting

See [troubleshooting.md](troubleshooting.md) for common issues.

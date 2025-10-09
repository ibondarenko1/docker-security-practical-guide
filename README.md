# Docker Security Practical Guide

A comprehensive, hands-on guide to Docker and container security with practical labs, real-world examples, and production-ready configurations.

## 🎯 Overview

This repository accompanies the DZone article "The Future of Docker Security" and provides executable examples for:
- Runtime security monitoring
- Container hardening
- Vulnerability scanning pipelines
- Image signing and verification
- Custom security profiles
- AI/ML workload security

## 📚 Labs

### [Lab 01: Falco Detection](labs/01-falco-detection/)
Real-time runtime security monitoring and threat detection

### [Lab 02: Secure Configurations](labs/02-secure-configs/)
Comparing insecure vs. hardened container configurations

### [Lab 03: Vulnerability Scanning](labs/03-vulnerability-scanning/)
Complete image scanning and SBOM generation pipeline

### [Lab 04: Image Signing](labs/04-image-signing/)
Implementing Docker Content Trust and Sigstore Cosign

### [Lab 05: Seccomp Profiles](labs/05-seccomp-profiles/)
Creating and testing custom syscall restriction profiles

### [Lab 06: AI Model Security](labs/06-ai-model-security/)
Securing ML inference containers with resource limits

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/docker-security-practical-guide.git
cd docker-security-practical-guide

# Run environment setup
./tools/setup-environment.sh

# Navigate to any lab and follow its README
cd labs/01-falco-detection
./run-lab.sh
```

## 📋 Prerequisites

- Docker 24.0+ installed
- Docker Compose v2+
- 8GB RAM minimum
- Linux or macOS (Windows WSL2 supported)
- Basic understanding of containers

## 🛠️ Tools Setup

The repository includes scripts to install required security tools:
- Trivy (vulnerability scanner)
- Cosign (image signing)
- Syft (SBOM generation)
- Grype (vulnerability matching)

## 📖 Documentation

- [Setup Guide](docs/setup-guide.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Additional Resources](docs/additional-resources.md)

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines and submit PRs.

## 📄 License

MIT License - see LICENSE file for details

## ⚠️ Security Notice

These labs include intentionally vulnerable configurations for educational purposes. 
**Never use insecure examples in production environments.**

## 🔗 Related Resources

- [Docker Security Docs](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [NIST Container Security Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-190.pdf)

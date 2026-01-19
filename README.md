...# Docker Security: A Practical Guide

A comprehensive, hands-on guide to Docker security best practices with real-world examples and lab exercises.

## 🎯 What You'll Learn

This guide takes you from basic Docker security concepts to advanced hardening techniques through practical, reproducible lab exercises. Each lab builds on previous knowledge while remaining self-contained.

### Core Topics Covered

- **Security Auditing**: Using Docker Bench Security for CIS compliance
- **Secure Images**: Building hardened, minimal container images
- **Least Privilege**: Implementing proper access controls
- **Secrets Management**: Protecting sensitive data
- **Network Security**: Isolating and securing container communications
- **Runtime Security**: Monitoring and protecting running containers

## 📚 Lab Structure

### [Lab 01: Security Auditing with Docker Bench](./labs/01-docker-bench-security/)

**What You'll Learn:**
- Run comprehensive security audits using Docker Bench Security
- Understand CIS Docker Benchmark compliance checks
- Identify common security misconfigurations
- Fix vulnerable container configurations

**Key Concepts:**
- Privileged container detection
- Network namespace isolation
- Capability management
- Security profile enforcement

### [Lab 02: Secure Container Configurations](./labs/02-secure-configs/)

**What You'll Learn:**
- Compare insecure vs secure container configurations
- Understand and apply Linux capabilities
- Implement read-only filesystems
- Use tmpfs for required write operations
- Apply security options like no-new-privileges

**Key Concepts:**
- Linux capability system
- Read-only root filesystems
- Capability dropping (drop all, add specific)
- tmpfs mounts with noexec and nosuid
- Container hardening without breaking functionality

### [Lab 03: Least Privilege Containers](./labs/03-least-privilege/)

**What You'll Learn:**
- Run containers as non-root users
- Drop unnecessary Linux capabilities
- Implement read-only filesystems
- Configure security contexts

**Key Concepts:**
- User namespace remapping
- Capability dropping
- Resource constraints
- Security policies

### [Lab 04: Image Signing and Verification](./labs/04-image-signing/)

**What You'll Learn:**
- Sign container images with Cosign
- Verify image signatures before deployment
- Implement Docker Content Trust
- Enforce signing policies
- Manage signing keys securely

**Key Concepts:**
- Digital signatures and cryptographic verification
- Cosign and Sigstore project
- Docker Content Trust (DCT)
- Keyless signing with OIDC
- Supply chain attack prevention
- Policy enforcement for signed images
### [Lab 05: Network Security](./labs/05-network-security/)

**What You'll Learn:**
- Configure secure Docker networks
- Implement network policies
- Use service mesh patterns
- Secure inter-container communication

**Key Concepts:**
- Custom bridge networks
- Network segmentation
- Encrypted communication
- Traffic control

### [Lab 06: AI Model Security](./labs/06-ai-model-security/)

**What You'll Learn:**
- Secure containerized machine learning workloads
- Set appropriate resource limits for ML containers
- Implement input validation and rate limiting
- Protect model intellectual property
- Monitor ML container behavior
- Deploy ML models securely in production

**Key Concepts:**
- Resource management for ML workloads
- Model extraction and adversarial attacks
- API authentication and authorization
- Input validation for ML endpoints
- Model encryption and access control
- Monitoring and anomaly detection for ML services

## 🚀 Getting Started

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Linux, macOS, or Windows with WSL2
- Basic Docker knowledge
- Terminal/command line familiarity

### Quick Start

1. **Clone the repository:**
```bash
git clone https://github.com/opscart/docker-security-practical-guide.git
cd docker-security-practical-guide
```

2. **Start with Lab 01:**
```bash
cd labs/01-docker-bench-security
./run-audit.sh
```

3. **Follow along with the README in each lab directory**

## 📖 How to Use This Guide

### For Beginners

1. Start with Lab 01 to understand security auditing
2. Progress sequentially through each lab
3. Complete all exercises before moving forward
4. Review the "Common Issues" sections

### For Experienced Users

1. Jump to specific labs based on your needs
2. Use as a reference for security patterns
3. Adapt examples to your use cases
4. Contribute improvements via pull requests

### For Security Auditors

1. Use Lab 01 for baseline security assessments
2. Reference CIS Benchmark mappings
3. Adapt checklists for your compliance needs
4. Document findings using provided templates

## 🔧 Lab Setup

Each lab is self-contained and includes:

- `README.md`: Comprehensive guide with theory and practice
- `docker-compose.yml`: Ready-to-run configurations
- Scripts: Automation for common tasks
- Examples: Both vulnerable and secure configurations

### Running a Lab

```bash
# Navigate to lab directory
cd labs/XX-lab-name

# Review the README
cat README.md

# Run the lab exercise
./run-demo.sh  # or specific lab script

# Clean up
./cleanup.sh
```

## 🎓 Learning Path

```
Lab 01: Security Auditing
    ↓
Lab 02: Secure Images
    ↓
Lab 03: Least Privilege
    ↓
Lab 04: Secrets Management
    ↓
Lab 05: Network Security
    ↓
Lab 06: Runtime Security
```

**Estimated Time:** 
- Each lab: 30-60 minutes
- Complete guide: 4-6 hours
- With practice exercises: 8-10 hours

## 🛠️ Tools & Technologies

### Security Tools Used

- **Docker Bench Security**: CIS compliance auditing
- **Trivy**: Vulnerability scanning
- **Cosign**: Container signing
- **Anchore**: Image analysis
- **Notary**: Content trust

### Technologies Covered

- Docker Engine
- Docker Compose
- Linux Security Modules (AppArmor, SELinux)
- Seccomp profiles
- User namespaces
- Capability systems

## 📝 Best Practices Summary

### Image Security
- Use minimal base images (alpine, distroless)
- Scan for vulnerabilities regularly
- Sign and verify images
- Use specific tags, never `latest`
- Implement multi-stage builds

### Runtime Security
- Run as non-root user
- Drop unnecessary capabilities
- Use read-only filesystems
- Enable security profiles
- Set resource limits

### Network Security
- Use custom bridge networks
- Avoid host network mode
- Implement network segmentation
- Encrypt traffic with TLS
- Control ingress/egress

### Secrets Management
- Never hardcode credentials
- Use Docker secrets or external vaults
- Rotate secrets regularly
- Limit secret access scope
- Audit secret usage

### Operational Security
- Regular security audits
- Keep Docker updated
- Monitor container behavior
- Log security events
- Incident response plan

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add your improvements
4. Test thoroughly
5. Submit a pull request

### Contribution Ideas

- Additional lab exercises
- Security tool integrations
- Cloud platform examples
- Kubernetes security labs
- Advanced threat scenarios

## 📚 Additional Resources

### Official Documentation
- [Docker Security](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Docker Bench Security](https://github.com/docker/docker-bench-security)

### Security Standards
- [NIST Container Security](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-190.pdf)
- [OWASP Docker Top 10](https://owasp.org/www-project-docker-top-10/)
- [CIS Controls](https://www.cisecurity.org/controls)

### Community Resources
- [Docker Security Subreddit](https://reddit.com/r/docker)
- [Docker Community Slack](https://dockercommunity.slack.com)
- [Stack Overflow Docker Tag](https://stackoverflow.com/questions/tagged/docker)

## 🐛 Troubleshooting

### Common Issues

**Issue: Permission denied running scripts**
```bash
chmod +x script-name.sh
```

**Issue: Docker daemon not running**
```bash
sudo systemctl start docker
```

**Issue: Port already in use**
```bash
docker ps  # Check running containers
docker-compose down  # Stop services
```

**Issue: Image pull failures**
```bash
docker login  # Authenticate if needed
docker pull image-name  # Manual pull to test
```

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details

## ✨ Acknowledgments

- Docker team for security tools and documentation
- CIS for the Docker Benchmark
- OWASP for security guidelines
- Open source security community

## 📧 Contact

- **Author**: [Your Name]
- **GitHub**: [@opscart](https://github.com/opscart)
- **Issues**: [Report issues](https://github.com/opscart/docker-security-practical-guide/issues)

---

**⭐ If you find this guide helpful, please star the repository!**

**🔒 Remember: Security is a journey, not a destination. Keep learning, keep improving!**

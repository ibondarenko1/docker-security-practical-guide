# Troubleshooting Guide

## Common Issues

### Docker Permission Denied

**Error**: `permission denied while trying to connect to the Docker daemon socket`

**Solution**:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Falco Installation Issues

**Error**: Falco fails to start or kernel module won't load

**Solution**:
```bash
# Install kernel headers
sudo apt-get install linux-headers-$(uname -r)

# Use eBPF probe instead of kernel module
docker run -d --name falco --privileged \
  -e FALCO_BPF_PROBE="" \
  falcosecurity/falco:latest
```

### Memory Issues

**Error**: Container killed due to OOM

**Solution**:
```bash
# Increase Docker memory limit (Docker Desktop)
# Settings → Resources → Memory → 8GB+

# Or use docker-compose with memory limits
docker-compose --compatibility up
```

### Port Conflicts

**Error**: `port is already allocated`

**Solution**:
```bash
# Find process using port
lsof -i :8080

# Kill process or change port in docker-compose.yml
```

## Getting Help

- Check lab-specific README files
- Review Docker logs: `docker logs <container-name>`
- Open an issue on GitHub with full error output

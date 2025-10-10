#!/bin/bash

cat << 'FIXES'
=== Common Docker Security Fixes ===

1. Enable Docker Content Trust
   Fix: export DOCKER_CONTENT_TRUST=1
   Add to: ~/.bashrc or ~/.zshrc

2. Configure audit logging
   Fix: 
   # Add to /etc/audit/rules.d/docker.rules
   -w /usr/bin/dockerd -k docker
   -w /var/lib/docker -k docker
   -w /etc/docker -k docker
   
   # Restart audit daemon
   sudo systemctl restart auditd

3. Enable user namespaces
   Fix:
   # Add to /etc/docker/daemon.json
   {
     "userns-remap": "default"
   }
   
   # Restart Docker
   sudo systemctl restart docker

4. Restrict network traffic between containers
   Fix:
   # Add to /etc/docker/daemon.json
   {
     "icc": false
   }

5. Enable AppArmor/SELinux
   Fix (Ubuntu/Debian):
   sudo apt-get install apparmor apparmor-utils
   sudo systemctl enable apparmor
   sudo systemctl start apparmor

6. Set logging level
   Fix:
   # Add to /etc/docker/daemon.json
   {
     "log-level": "info"
   }

7. Disable legacy registry (v1)
   Fix:
   # Add to /etc/docker/daemon.json
   {
     "disable-legacy-registry": true
   }

For complete fixes, see:
https://github.com/docker/docker-bench-security

FIXES

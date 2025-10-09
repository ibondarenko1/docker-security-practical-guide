#!/bin/bash

echo "Generating custom seccomp profile for nginx..."

# This would normally use tools like strace to capture syscalls
# For demo purposes, we create a nginx-specific profile

cat > nginx-profile.json << 'PROFILE'
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64"],
  "syscalls": [
    {
      "names": [
        "accept4", "access", "arch_prctl", "bind", "brk", "chdir",
        "close", "dup2", "epoll_create", "epoll_ctl", "epoll_wait",
        "exit_group", "fcntl", "fstat", "futex", "getcwd", "getdents64",
        "getegid", "geteuid", "getgid", "getpid", "getppid", "getuid",
        "ioctl", "listen", "lseek", "mmap", "mprotect", "munmap",
        "open", "openat", "read", "readlink", "recvfrom", "rt_sigaction",
        "rt_sigprocmask", "rt_sigreturn", "sendfile", "sendto",
        "set_robust_list", "set_tid_address", "setgid", "setgroups",
        "setuid", "socket", "stat", "write", "writev"
      ],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
PROFILE

echo "Profile generated: nginx-profile.json"
echo ""
echo "Testing nginx with custom profile..."

docker run -d --name nginx-secure \
  --security-opt seccomp=nginx-profile.json \
  -p 8080:80 \
  nginx:alpine

sleep 2
curl -s http://localhost:8080 > /dev/null && echo "✓ Nginx running successfully with restrictive profile"

docker stop nginx-secure && docker rm nginx-secure

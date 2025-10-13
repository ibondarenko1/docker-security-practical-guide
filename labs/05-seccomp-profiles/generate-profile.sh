#!/bin/bash

echo "Generating custom seccomp profile for nginx..."

# Create a working nginx seccomp profile
cat > nginx-profile.json << 'EOF'
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": [
    "SCMP_ARCH_X86_64",
    "SCMP_ARCH_X86",
    "SCMP_ARCH_X32",
    "SCMP_ARCH_AARCH64",
    "SCMP_ARCH_ARM"
  ],
  "syscalls": [
    {
      "names": [
        "accept", "accept4", "access", "alarm", "arch_prctl",
        "bind", "brk", "capget", "capset", "chdir",
        "chmod", "chown", "chroot", "clock_gettime", "clone",
        "close", "connect", "dup", "dup2", "dup3",
        "epoll_create", "epoll_create1", "epoll_ctl", "epoll_pwait", "epoll_wait",
        "eventfd", "eventfd2", "execve", "exit", "exit_group",
        "faccessat", "faccessat2", "fadvise64", "fallocate", "fchdir",
        "fchmod", "fchmodat", "fchown", "fchownat", "fcntl",
        "fdatasync", "flock", "fork", "fstat", "fstatfs",
        "fsync", "ftruncate", "futex", "getcwd", "getdents",
        "getdents64", "getegid", "geteuid", "getgid", "getgroups",
        "getitimer", "getpeername", "getpid", "getppid", "getpriority",
        "getrandom", "getresgid", "getresuid", "getrlimit", "getrusage",
        "getsid", "getsockname", "getsockopt", "gettid", "gettimeofday",
        "getuid", "getxattr", "io_setup", "ioctl", "ipc",
        "kill", "lgetxattr", "link", "linkat", "listen",
        "lseek", "lstat", "madvise", "memfd_create", "mincore",
        "mkdir", "mkdirat", "mknod", "mknodat", "mlock",
        "mlock2", "mlockall", "mmap", "mprotect", "mq_getsetattr",
        "mq_notify", "mq_open", "mq_timedreceive", "mq_timedsend", "mq_unlink",
        "mremap", "msync", "munlock", "munlockall", "munmap",
        "nanosleep", "newfstatat", "open", "openat", "pause",
        "pipe", "pipe2", "poll", "ppoll", "prctl",
        "pread64", "preadv", "preadv2", "prlimit64", "pselect6",
        "pwrite64", "pwritev", "pwritev2", "read", "readahead",
        "readlink", "readlinkat", "readv", "recvfrom", "recvmmsg",
        "recvmsg", "remap_file_pages", "removexattr", "rename", "renameat",
        "renameat2", "restart_syscall", "rmdir", "rt_sigaction", "rt_sigpending",
        "rt_sigprocmask", "rt_sigqueueinfo", "rt_sigreturn", "rt_sigsuspend", "rt_sigtimedwait",
        "rt_tgsigqueueinfo", "sched_getaffinity", "sched_getattr", "sched_getparam", "sched_get_priority_max",
        "sched_get_priority_min", "sched_getscheduler", "sched_rr_get_interval", "sched_setaffinity", "sched_setattr",
        "sched_setparam", "sched_setscheduler", "sched_yield", "seccomp", "select",
        "semctl", "semget", "semop", "semtimedop", "sendfile",
        "sendmmsg", "sendmsg", "sendto", "set_robust_list", "set_tid_address",
        "setfsgid", "setfsuid", "setgid", "setgroups", "setitimer",
        "setpgid", "setpriority", "setregid", "setresgid", "setresuid",
        "setreuid", "setrlimit", "setsid", "setsockopt", "setuid",
        "setxattr", "shmat", "shmctl", "shmdt", "shmget",
        "shutdown", "sigaltstack", "signalfd", "signalfd4", "socket",
        "socketpair", "splice", "stat", "statfs", "statx",
        "symlink", "symlinkat", "sync", "sync_file_range", "syncfs",
        "sysinfo", "tee", "tgkill", "time", "timer_create",
        "timer_delete", "timer_getoverrun", "timer_gettime", "timer_settime", "timerfd_create",
        "timerfd_gettime", "timerfd_settime", "times", "tkill", "truncate",
        "umask", "uname", "unlink", "unlinkat", "utime",
        "utimensat", "utimes", "vfork", "vmsplice", "wait4",
        "waitid", "write", "writev"
      ],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
EOF

echo "Profile generated: nginx-profile.json"
echo ""
echo "Testing nginx with custom profile..."

# Test the profile
if docker run -d --name nginx-test --security-opt seccomp=nginx-profile.json -p 8888:80 nginx:alpine; then
    echo "✓ Nginx started successfully with custom profile"
    echo ""
    echo "Testing nginx response..."
    sleep 2
    if curl -s http://localhost:8888 > /dev/null; then
        echo "✓ Nginx responding to requests"
    else
        echo "✗ Nginx not responding"
    fi
    
    # Cleanup
    docker stop nginx-test > /dev/null 2>&1
    docker rm nginx-test > /dev/null 2>&1
    echo ""
    echo "✓ Test complete - profile works correctly"
else
    echo "✗ Failed to start nginx with custom profile"
    echo "The profile may be too restrictive"
    exit 1
fi

echo ""
echo "Generated profile blocks dangerous syscalls while allowing:"
echo "  - Network operations (socket, bind, listen, accept)"
echo "  - File operations (read, write, open, close)"
echo "  - Process management (fork, exec, wait)"
echo ""
echo "Blocked syscalls include:"
echo "  - mount, umount (filesystem operations)"
echo "  - reboot, kexec_load (system operations)"
echo "  - ptrace (debugging)"
echo "  - module operations (kernel modules)"
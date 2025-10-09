# Lab 04: Image Signing and Verification

## Objectives

- Sign container images with Cosign
- Verify image signatures
- Implement Docker Content Trust
- Establish trust chains

## Prerequisites

- Cosign installed
- Docker registry access (or use local registry)

## Lab Steps

### 1. Setup Image Signing

```bash
./setup-signing.sh
```

### 2. Sign Container Image

```bash
./sign-image.sh
```

### 3. Verify Signature

```bash
./verify-image.sh
```

### 4. Test Enforcement

```bash
./test-enforcement.sh
```

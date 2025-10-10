#!/bin/bash

# Verification script to ensure all Falco references are removed
# and replaced with Docker Bench Security (Updated for new directory name)

set -e

REPO_ROOT="/home/docker-poc/docker-security-practical-guide"
cd "$REPO_ROOT"

echo "=========================================="
echo "Verification: Falco to Docker Bench Migration"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for issues
ISSUES=0

# Function to check for Falco references
check_falco_references() {
    local file=$1
    if [ -f "$file" ]; then
        if grep -qi "falco" "$file" 2>/dev/null; then
            echo -e "${RED}✗ FOUND Falco reference in: $file${NC}"
            grep -ni "falco" "$file" | head -5
            ((ISSUES++))
        else
            echo -e "${GREEN}✓ No Falco references in: $file${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ File not found: $file${NC}"
        ((ISSUES++))
    fi
}

# Function to check for Docker Bench references
check_docker_bench_references() {
    local file=$1
    if [ -f "$file" ]; then
        if grep -qi "docker bench\|docker-bench" "$file" 2>/dev/null; then
            echo -e "${GREEN}✓ Contains Docker Bench reference: $file${NC}"
        else
            echo -e "${YELLOW}⚠ Missing Docker Bench reference in: $file${NC}"
            ((ISSUES++))
        fi
    fi
}

echo "1. Checking for remaining Falco references..."
echo "--------------------------------------------"

check_falco_references "README.md"
check_falco_references "article.md"
check_falco_references "labs/01-docker-bench-security/README.md"
check_falco_references "labs/01-docker-bench-security/run-audit.sh"

# Check if old directory still exists
if [ -d "labs/01-falco-detection" ]; then
    echo -e "${RED}✗ Old directory still exists: labs/01-falco-detection${NC}"
    ((ISSUES++))
else
    echo -e "${GREEN}✓ Old directory removed: labs/01-falco-detection${NC}"
fi

echo ""
echo "2. Verifying Docker Bench Security references..."
echo "--------------------------------------------"

check_docker_bench_references "README.md"
check_docker_bench_references "article.md"
check_docker_bench_references "labs/01-docker-bench-security/README.md"
check_docker_bench_references "labs/01-docker-bench-security/run-audit.sh"

echo ""
echo "3. Checking file executability..."
echo "--------------------------------------------"

if [ -x "labs/01-docker-bench-security/run-audit.sh" ]; then
    echo -e "${GREEN}✓ run-audit.sh is executable${NC}"
else
    echo -e "${RED}✗ run-audit.sh is NOT executable${NC}"
    echo "  Run: chmod +x labs/01-docker-bench-security/run-audit.sh"
    ((ISSUES++))
fi

echo ""
echo "4. Checking directory structure..."
echo "--------------------------------------------"

REQUIRED_FILES=(
    "labs/01-docker-bench-security/README.md"
    "labs/01-docker-bench-security/run-audit.sh"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ Required file exists: $file${NC}"
    else
        echo -e "${RED}✗ Missing required file: $file${NC}"
        ((ISSUES++))
    fi
done

echo ""
echo "=========================================="
echo "Verification Summary"
echo "=========================================="

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Migration is complete. Next steps:"
    echo "  1. Test the lab:"
    echo "     cd labs/01-docker-bench-security"
    echo "     ./run-audit.sh"
    echo ""
    echo "  2. Review changes:"
    echo "     git diff"
    echo ""
    echo "  3. Remove migration scripts:"
    echo "     rm complete-falco-to-bench-update.sh"
    echo "     rm verify-falco-removal.sh"
    echo "     rm rename-lab-directory.sh"
    echo ""
    echo "  4. Commit and push:"
    echo "     git add ."
    echo "     git commit -m 'Complete Falco to Docker Bench Security migration'"
    echo "     git push origin main"
else
    echo -e "${RED}✗ FOUND $ISSUES ISSUE(S)${NC}"
    echo ""
    echo "Please review the issues above and run this script again."
fi

echo "=========================================="
echo ""

# Optional: Show git status
if command -v git &> /dev/null; then
    echo "Git Status:"
    git status --short
fi

exit $ISSUES

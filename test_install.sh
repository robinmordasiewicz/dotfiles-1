#!/bin/bash

echo "Testing the install.sh script fix..."

cd /home/rmordasiewicz@fortinet-us.com/40docs/dotfiles || exit 1

echo "Running syntax check..."
if bash -n install.sh; then
    echo "✓ Syntax check passed"
else
    echo "✗ Syntax check failed"
    exit 1
fi

echo "Testing help option..."
if timeout 10s bash install.sh --help >/dev/null 2>&1; then
    echo "✓ Help option works"
else
    echo "✗ Help option failed or timed out"
fi

echo "Testing with actual execution (should show initial logs)..."
timeout 5s bash install.sh 2>&1 | head -5

echo "Test completed."

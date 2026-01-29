#!/bin/bash
# Regression test: Config loads without errors

set -euo pipefail

echo "Testing: Config loads without errors"

if nvim --headless -c 'quit' 2>&1 > /dev/null; then
    echo "✓ PASS: Config loads"
    exit 0
else
    echo "✗ FAIL: Config broken"
    nvim --headless -c 'quit' 2>&1
    exit 1
fi

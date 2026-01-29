#!/bin/bash
# Regression test: All plugins load correctly

set -euo pipefail

echo "Testing: Plugin health"

OUTPUT=$(nvim --headless +'checkhealth lazy' +'quit' 2>&1)

if echo "$OUTPUT" | grep -q "ERROR"; then
    echo "✗ FAIL: Plugin errors found"
    echo "$OUTPUT" | grep "ERROR"
    exit 1
else
    echo "✓ PASS: All plugins healthy"
    exit 0
fi

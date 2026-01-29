#!/bin/bash
# Regression test: LSP servers are configured

set -euo pipefail

echo "Testing: LSP configuration"

OUTPUT=$(nvim --headless +'checkhealth lsp' +'quit' 2>&1)

if echo "$OUTPUT" | grep -q "ERROR"; then
    echo "✗ FAIL: LSP errors found"
    echo "$OUTPUT" | grep "ERROR"
    exit 1
else
    echo "✓ PASS: LSP healthy"
    exit 0
fi

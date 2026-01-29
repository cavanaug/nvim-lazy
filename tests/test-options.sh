#!/bin/bash
# Regression test: Critical options are set correctly

set -euo pipefail

echo "Testing: Core options"

# Test leader keys
LEADER=$(nvim --headless -c 'lua print(vim.g.mapleader)' -c 'quit' 2>&1 | tail -1)
LOCALLEADER=$(nvim --headless -c 'lua print(vim.g.maplocalleader)' -c 'quit' 2>&1 | tail -1)

if [ "$LEADER" = " " ] && [ "$LOCALLEADER" = "," ]; then
    echo "✓ PASS: Leader keys correct"
    exit 0
else
    echo "✗ FAIL: Leader keys incorrect (leader='$LEADER', localleader='$LOCALLEADER')"
    exit 1
fi

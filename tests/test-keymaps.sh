#!/bin/bash
# Test that keymaps load without errors

echo "Testing: Keymap loading"

# Test that config/keymaps.lua loads without errors
output=$(nvim --headless -c 'lua require("config.keymaps")' -c 'quit' 2>&1)
exit_code=$?

if [ $exit_code -eq 0 ] && ! echo "$output" | grep -qi "error"; then
    echo "✓ PASS: Keymaps load without errors"
    exit 0
else
    echo "✗ FAIL: Keymap errors detected:"
    echo "$output"
    exit 1
fi

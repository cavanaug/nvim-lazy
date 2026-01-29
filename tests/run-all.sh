#!/bin/bash
# Run all regression tests

set -euo pipefail

TESTS_DIR="$HOME/.config/nvim/tests"
FAILED=0

echo "================================================"
echo "Running Neovim Configuration Regression Tests"
echo "================================================"
echo ""

for test in "$TESTS_DIR"/test-*.sh; do
    if [ -f "$test" ] && [ "$test" != "$TESTS_DIR/run-all.sh" ]; then
        echo "Running: $(basename "$test")"
        if bash "$test"; then
            echo ""
        else
            FAILED=$((FAILED + 1))
            echo ""
        fi
    fi
done

echo "================================================"
if [ $FAILED -eq 0 ]; then
    echo "✅ All tests passed!"
    exit 0
else
    echo "❌ $FAILED test(s) failed"
    exit 1
fi

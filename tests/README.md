# Regression Test Suite

This directory contains **permanent regression tests** that validate the Neovim configuration.

## Purpose

These tests ensure that configuration changes don't break existing functionality. All tests should pass after any modification to the configuration.

## Running Tests

### Run All Tests
```bash
bash ~/.config/nvim/tests/run-all.sh
```

### Run Individual Test
```bash
bash ~/.config/nvim/tests/test-config.sh
bash ~/.config/nvim/tests/test-plugins.sh
bash ~/.config/nvim/tests/test-lsp.sh
bash ~/.config/nvim/tests/test-options.sh
```

## Test Files

- **test-config.sh** - Validates that Neovim config loads without errors
- **test-plugins.sh** - Checks plugin health via `:checkhealth lazy`
- **test-lsp.sh** - Validates LSP configuration
- **test-options.sh** - Verifies critical options (leader keys, etc.)
- **run-all.sh** - Master script that runs all tests

## Writing New Tests

When adding significant functionality, consider creating a new regression test:

```bash
#!/bin/bash
# Regression test: Description of what this tests

set -euo pipefail

echo "Testing: Your test description"

# Your test logic here
OUTPUT=$(nvim --headless -c 'lua print("test")' -c 'quit' 2>&1)

if [ condition ]; then
    echo "✓ PASS: Test passed"
    exit 0
else
    echo "✗ FAIL: Test failed"
    exit 1
fi
```

Make sure to:
1. Use `set -euo pipefail` for strict error handling
2. Run tests in headless mode (`nvim --headless`)
3. Exit with 0 for success, 1 for failure
4. Provide clear pass/fail messages
5. Make the script executable: `chmod +x test-name.sh`

## Important Notes

- **These tests are version controlled** - they persist across configuration changes
- Tests should be **fast** and **deterministic**
- All tests must pass before changes are considered complete
- For temporary/disposable test files, use the `tmp/` directory instead

## See Also

- `tmp/` - Temporary scratch files (gitignored)
- `AGENTS.md` - Full testing workflow documentation

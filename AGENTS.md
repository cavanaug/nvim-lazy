# Neovim Configuration Guide for AI Agents

## Overview

This is a comprehensive Neovim configuration built on top of **LazyVim**, featuring extensive language support, AI integrations, and custom workflows. The configuration uses lazy.nvim for plugin management and follows LazyVim's modular architecture.

**Official Documentation**: [LazyVim Documentation](https://lazyvim.org)

## Architecture

### Plugin Management System

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast and modern plugin manager
- **Base Framework**: [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration framework built on lazy.nvim
- **Plugin Source**: `~/.local/share/nvim` - Location where all plugin source code is stored, this area is NEVER to be modified directly
- **Lock File**: `lazy-lock.json` - Pins exact plugin versions for reproducible builds

### Data & Cache Locations

**Plugin Data Directories**:
- **`~/.local/share/nvim/lazy/`** - Plugin source code repositories (managed by lazy.nvim)
- **`~/.local/share/nvim/mason/`** - LSP servers, formatters, linters installed by Mason
- **`~/.local/share/nvim/blink/`** - Blink.cmp completion data
- **`~/.cache/nvim/`** - Plugin cache files, logs, and temporary data
- **`~/.local/state/nvim/`** - Persistent state data (sessions, undo history)

**For Documentation & Debugging**:
- Use `ls ~/.local/share/nvim/lazy/` to see all installed plugins
- Plugin source code at `~/.local/share/nvim/lazy/<plugin-name>/` contains:
  - README.md files with documentation
  - `doc/` directories with help files  
  - `lua/` directories with source code for understanding plugin internals
  - Example configurations in plugin repositories
- Check `~/.cache/nvim/` for plugin logs (e.g., `diffview.log`, `telescope.log`)
- Mason tools are in `~/.local/share/nvim/mason/bin/` and `~/.local/share/nvim/mason/packages/`
- **Neovim Core Documentation**: Find version-specific help files at `/home/linuxbrew/.linuxbrew/Cellar/neovim/<version>/share/nvim/runtime/doc/`
  - Use `ls /home/linuxbrew/.linuxbrew/Cellar/neovim/` to see available versions
  - Contains core vim help files (api.txt, autocmd.txt, cmdline.txt, etc.)
  - Use `find /home/linuxbrew/.linuxbrew/Cellar/neovim/ -name "*.txt" -path "*/doc/*"` to locate all help files
  - Access via `:help <topic>` in Neovim or examine files directly for comprehensive documentation
- Use `:checkhealth` in Neovim to see plugin status and potential issues

**Advanced Debugging & Development**:
- **Live Inspection**: Use `:lua print(vim.inspect(<object>))` to inspect Lua objects and configurations
- **Plugin Loading**: Check `:Lazy profile` for plugin loading times and performance bottlenecks
- **LSP Debugging**: Use `:LspInfo`, `:LspLog`, and `:Mason` for language server troubleshooting
- **Startup Performance**: Use `:Lazy profile` and the `startuptime` extra for optimization
- **Configuration Reload**: Use `:source %` for individual files or `:Lazy reload <plugin>` for plugins
- **Error Tracking**: Check `:messages` for recent error messages and warnings
- **Plugin State**: Use `:Lazy` interface to see plugin status, updates, and configuration
- **Key Mappings**: Use `:map`, `:nmap`, `:imap` etc. to inspect current key bindings
- **Options Inspection**: Use `:set <option>?` to check current option values
- **Autocommands**: Use `:autocmd` to list active autocommands and their triggers

### Directory Structure

```
/home/cavanaug/.config/nvim/
├── init.lua                    # Entry point - bootstraps lazy.nvim and LazyVim
├── lazyvim.json               # LazyVim extras configuration
├── lazy-lock.json             # Plugin version lockfile
├── stylua.toml                # Lua code formatter configuration
├── lua/
│   ├── config/                # Core configuration
│   │   ├── autocmds.lua       # Custom autocommands
│   │   ├── keymaps.lua        # Custom keybindings
│   │   ├── lazy.lua           # Lazy.nvim setup and plugin loading
│   │   └── options.lua        # Vim options and global settings
│   └── plugins/               # Plugin configurations
│       └── *.lua              # Individual plugin configuration files
├── tests/                     # Regression tests (version controlled)
│   ├── run-all.sh            # Master test runner
│   └── test-*.sh             # Individual test scripts
├── tmp/                       # Temporary scratch files (gitignored)
└── spell/                     # Custom spell checking dictionaries
    ├── en.utf-8.add           # Custom word additions
    └── en.utf-8.add.spl       # Compiled spell file
```

## Discovering Current Configuration

**Always check the current state before suggesting changes.** This configuration uses dynamic discovery rather than static documentation.

### Installed Plugins & Versions
- **List all installed plugins**: `ls ~/.local/share/nvim/lazy/`
- **Check locked versions**: `cat lazy-lock.json | jq` (or use `less`/`grep`)
- **Interactive plugin manager**: In Neovim, run `:Lazy`
- **Custom plugin files**: `ls lua/plugins/`
- **Read plugin configuration**: `cat lua/plugins/<name>.lua`

### LazyVim Extras
- **List enabled extras**: `cat lazyvim.json | jq '.extras'`
- **Browse/toggle available extras**: In Neovim, run `:LazyExtras`
- **Official extras catalog**: https://lazyvim.org/extras
- **IMPORTANT**: Always check if needed functionality exists as an extra before creating custom plugin configs

### Core Configuration Files
- **Options & globals**: `cat lua/config/options.lua`
- **Custom keymaps**: `cat lua/config/keymaps.lua`
- **Autocommands**: `cat lua/config/autocmds.lua`
- **Plugin bootstrap**: `cat lua/config/lazy.lua`
- **Entry point**: `cat init.lua`

### Active Runtime State
- **Current colorscheme**: `:lua print(vim.g.colors_name)`
- **Leader keys**: `:lua print("Leader: " .. vim.g.mapleader .. ", Local: " .. vim.g.maplocalleader)`
- **Picker preference**: `:lua print(vim.g.lazyvim_picker)` (returns: auto/snacks/telescope/fzf)
- **Completion engine**: `:lua print(vim.g.lazyvim_cmp)` (returns: auto/nvim-cmp/blink.cmp)
- **LSP servers**: `:Mason` or `:LspInfo`
- **Neovim version**: `:lua print(vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)`

### Finding Issues, TODOs, and Plans
- **Health check**: `:checkhealth`
- **Backlog & TODOs**: `cat README.md`
- **Search config for TODOs**: `grep -r TODO lua/`
- **Recent errors**: `:messages`
- **LSP logs**: `:LspLog`
- **Plugin-specific logs**: `ls ~/.cache/nvim/*.log`

### Standard Data Locations
- **Config directory**: `:lua print(vim.fn.stdpath('config'))` → `~/.config/nvim`
- **Data directory**: `:lua print(vim.fn.stdpath('data'))` → `~/.local/share/nvim`
- **Cache directory**: `:lua print(vim.fn.stdpath('cache'))` → `~/.cache/nvim`
- **State directory**: `:lua print(vim.fn.stdpath('state'))` → `~/.local/state/nvim`

### Documentation Priority

**CRITICAL: Always consult local documentation FIRST before web searches or MCP servers.**

This configuration includes comprehensive local documentation that should be your primary resource:

#### 1. Neovim Core Documentation (FIRST)
- **Location**: `/home/linuxbrew/.linuxbrew/Cellar/neovim/<version>/share/nvim/runtime/doc/`
- **Access**: Use `:help <topic>` in Neovim for interactive help
- **Direct access**: Read text files directly for automation/scripting
- **Find all help files**: `find /home/linuxbrew/.linuxbrew/Cellar/neovim/ -name "*.txt" -path "*/doc/*"`
- **Examples**:
  - `:help api` - Neovim API documentation
  - `:help autocmd` - Autocommand documentation
  - `:help lua` - Lua integration in Neovim
  - `:help options` - All Neovim options

#### 2. Plugin Documentation (SECOND)
- **Location**: `~/.local/share/nvim/lazy/<plugin-name>/`
- **Contents**:
  - `README.md` - Plugin overview and quick start
  - `doc/*.txt` - Vim help files (access via `:help <plugin>`)
  - `lua/` - Source code for understanding implementation
- **Access installed plugins**: `ls ~/.local/share/nvim/lazy/`
- **Examples**:
  - `~/.local/share/nvim/lazy/LazyVim/` - LazyVim framework docs
  - `~/.local/share/nvim/lazy/nvim-lspconfig/` - LSP configuration
  - `~/.local/share/nvim/lazy/snacks.nvim/` - Snacks plugin docs

#### 3. LazyVim Official Documentation (THIRD)
- **URL**: https://lazyvim.org
- **Purpose**: Official LazyVim extras catalog, configuration guides
- **When to use**: When local docs don't cover LazyVim-specific features

#### 4. Web/MCP Resources (LAST RESORT)
- Only use external MCP servers or web searches when:
  - Local documentation doesn't contain the information
  - You need real-world examples from GitHub
  - You need to fetch external API documentation
  - You're researching new plugins not yet installed

**Workflow Summary**:
```
1. `:help <topic>` in Neovim
2. Check plugin README/docs in ~/.local/share/nvim/lazy/<plugin>/
3. Browse https://lazyvim.org
4. Use MCP servers (e.g., gh_grep) for external resources only when needed
```

## Key Configuration Files

### Entry Point (`init.lua`)

Bootstrapper that loads `config.lazy` - follows LazyVim's minimal approach.

**To inspect**: `cat init.lua`

### Core Configuration (`lua/config/`)

#### `lazy.lua` - Plugin Management
Bootstraps lazy.nvim and configures LazyVim as the base framework. Custom plugins are loaded from the `plugins/` directory.

**To inspect**: `cat lua/config/lazy.lua`

#### `options.lua` - Core Settings  
Contains Vim options, global settings, leader key definitions, and LazyVim behavior configuration (picker preference, completion engine, etc.).

**To inspect**: `cat lua/config/options.lua`  
**To check active values in Neovim**: 
- Specific option: `:set <option>?`
- Global variable: `:lua print(vim.g.<variable>)`
- All options: `:set all`

#### `keymaps.lua` - Custom Keybindings
Custom keybindings that supplement or override LazyVim defaults.

**To inspect**: `cat lua/config/keymaps.lua`  
**To check active keymaps in Neovim**: 
- LazyVim which-key interface: Press `<Space>` and wait
- Snacks picker search: `Snacks.picker.keymaps()`
- Vim commands: `:map`, `:nmap`, `:imap`, etc.

#### `autocmds.lua` - Autocommands
Custom autocommands for filetype detection, spell checking, tmux integration, and editor behavior.

**To inspect**: `cat lua/config/autocmds.lua`  
**To check active autocommands in Neovim**: `:autocmd`

## Customization Philosophy

### Configuration Approach

- **LazyVim Extras First**: This configuration heavily relies on LazyVim's curated extras system
  - **Before adding any plugin**: Check https://lazyvim.org/extras for available extras
  - **Prefer extras over custom**: LazyVim extras are pre-configured, tested, and maintained by the LazyVim team
  - **Enable via lazyvim.json**: Use `:LazyExtras` in Neovim to browse and enable extras
  - **Custom only when necessary**: Create custom plugin configs only for:
    - Plugins not available as LazyVim extras
    - Overrides/extensions to existing extras
    - Setup-specific customizations unique to this configuration
  - **Avoid capability conflicts**: Don't install custom versions of plugins already provided by LazyVim or available as extras

- **Base + Overrides**: LazyVim provides the base configuration with sensible defaults
  - This setup selectively overrides and extends those defaults through:
    - **LazyVim extras** (enabled in `lazyvim.json`) - **PRIMARY METHOD**
    - **Custom plugin configurations** (`lua/plugins/*.lua`) - **ONLY WHEN NEEDED**
    - **Core setting overrides** (`lua/config/*.lua`)

- **Prefer Built-in LazyVim Plugins**: When multiple options exist, prefer plugins maintained by the LazyVim author (folke)
  - Example: **Snacks** (built-in) is preferred over **Telescope** (available as extra)
  - These plugins are designed to work seamlessly together and receive priority support

- **Plugin Management**: All plugins are managed by lazy.nvim and installed under `~/.local/share/nvim/`
  - **CRITICAL**: NEVER modify files under `~/.local/share/nvim/` directly unless explicitly approved
  - This directory contains plugin source code managed by the package manager
  - All customizations should go in:
    - `lazyvim.json` for enabling extras (preferred)
    - `~/.config/nvim/lua/plugins/` for custom plugin configs (when necessary)
    - `lua/config/` for core Neovim settings

- **Muscle Memory**: Configuration preserves familiar keybindings where possible while adopting LazyVim conventions

- **Modular Architecture**: Each custom plugin configuration lives in its own file under `lua/plugins/` for maintainability

### Documentation Strategy

- **Inline Comments**: Extensive commenting in configuration files
- **Backlog Tracking**: README.md tracks TODOs, learning targets, and future improvements
- **Architecture Documentation**: This AGENTS.md file provides guidance for AI assistants
- **Official Reference**: Always consult https://lazyvim.org for latest LazyVim features and extras

## Working with This Configuration

### Preferred Tools & Workflow

**LazyVim-First Philosophy**:

This configuration **strongly prefers using LazyVim-supplied plugins and extras** over custom installations.

#### Workflow for Adding Functionality

**Always follow this order:**

1. **Check LazyVim Extras First**: 
   - Browse available extras: https://lazyvim.org/extras
   - In Neovim: `:LazyExtras`
   - Check what's currently enabled: `cat lazyvim.json | jq '.extras'`

2. **Verify Not Already Configured**:
   - Check existing custom plugins: `ls lua/plugins/`
   - Review relevant config file: `cat lua/plugins/<name>.lua`

3. **If uncertain, ASK the user**:
   - Don't assume - clarify whether to use an extra or create custom config
   - Explain the tradeoffs if multiple options exist

4. **Implementation Priority**:
   - ✅ **FIRST**: Enable LazyVim extra (if available)
   - ✅ **SECOND**: Create custom plugin config (if needed)
   - ❌ **NEVER**: Install plugin that duplicates LazyVim extra functionality

5. **ALWAYS Test Before Finalizing**:
   - Use `tmp/` directory for test files
   - Launch Neovim headlessly and verify with exit codes and health checks
   - Test actual functionality
   - Run regression test suite
   - Only move to final location after successful testing

#### Key Principles

**Avoid Capability Conflicts**:
- Don't install custom versions of plugins already provided by LazyVim
- Don't create custom configs for plugins available as extras
- When in doubt about conflicts, ask the user for clarification

**Prefer Built-in LazyVim Plugins**:
- When multiple options exist, prefer plugins by the LazyVim author (folke)
- Example: **Snacks** (built-in) over **Telescope** (available as extra)
- Built-in plugins are designed to work seamlessly and receive priority support

**Custom Plugins Are Acceptable When**:
- Functionality is NOT available as a LazyVim extra
- You need to override/extend existing extra configuration
- Plugin is truly unique to this setup

#### Primary Tools in This Configuration

**Picker/Fuzzy Finder**:
- **Primary**: Snacks picker (`lazyvim.plugins.extras.editor.snacks_picker`)
- Also available: FZF (`lazyvim.plugins.extras.editor.fzf`)
- **Usage in Neovim**:
  - Files: `Snacks.picker.files()`
  - Grep: `Snacks.picker.grep()`
  - Buffers: `Snacks.picker.buffers()`
  - Keymaps: `Snacks.picker.keymaps()`
  - See `:help snacks.picker` for full reference
- **When providing examples**: Use Snacks picker commands, NOT Telescope

**Completion Engine**:
- **Auto-detected**: Set to `"auto"` in `vim.g.lazyvim_cmp`
- Supports both nvim-cmp and blink.cmp
- Check active: `:lua print(vim.g.lazyvim_cmp)`

**AI Assistants**:
- GitHub Copilot (`lazyvim.plugins.extras.ai.copilot`)
- Copilot Chat (`lazyvim.plugins.extras.ai.copilot-chat`)
- Sidekick (`lazyvim.plugins.extras.ai.sidekick`)

### Testing Configuration Changes

**CRITICAL: Always test changes headlessly before considering them complete.** AI agents must validate changes programmatically, not through user interaction.

#### Testing Directory Structure

```
~/.config/nvim/
├── tmp/                    # Temporary scratch files (disposable)
│   ├── test-plugin.lua    # Quick test files
│   └── scratch.lua        # Experimental code
└── tests/                  # Ongoing regression tests (permanent)
    ├── run-all.sh         # Master test runner
    ├── test-config.sh     # Config load tests
    ├── test-plugins.sh    # Plugin validation tests
    └── test-lsp.sh        # LSP functionality tests
```

**Usage**:
- **tmp/**: Disposable test files, experiments, one-off validations
- **tests/**: Permanent test suite that should pass after any config change

#### Headless Testing Workflow

**All tests should run in headless mode** to enable automation and verification without user interaction.

1. **Create Temporary Files in tmp/**:
   ```bash
   # tmp/ is gitignored and safe for disposable experiments
   mkdir -p ~/.config/nvim/tmp
   
   # Create test files here for one-off experiments
   cat > ~/.config/nvim/tmp/test-new-idea.lua << 'EOF'
   return {
     "author/plugin-name",
     opts = {}
   }
   EOF
   ```

2. **Basic Headless Validation**:
   ```bash
   # Test if Neovim starts without errors
   nvim --headless --noplugin -c 'quit' 2>&1
   
   # Test with full config
   nvim --headless -c 'quit' 2>&1
   
   # Exit code 0 = success, non-zero = error
   echo $?
   ```

3. **Test Plugin Configuration Headlessly**:
   ```bash
   # Create test plugin in tmp/ (disposable)
   cat > ~/.config/nvim/tmp/test-plugin.lua << 'EOF'
   return {
     "author/plugin-name",
     opts = {
       -- your test configuration
     },
   }
   EOF
   
   # Copy to lua/plugins/ for testing
   cp ~/.config/nvim/tmp/test-plugin.lua ~/.config/nvim/lua/plugins/
   
   # Headless test: Load config and check for errors
   nvim --headless +'checkhealth lazy' +'quit' 2>&1 | tee /tmp/nvim-test.log
   
   # Check exit code
   if [ $? -eq 0 ]; then
     echo "✓ Config loaded successfully"
   else
     echo "✗ Config failed - check /tmp/nvim-test.log"
     cat /tmp/nvim-test.log
   fi
   ```

4. **Run Regression Test Suite**:
   ```bash
   # After making any config change, run existing tests
   # to ensure nothing broke
   
   # Run all tests in tests/
   bash ~/.config/nvim/tests/run-all.sh
   ```

5. **Validate with Lua Commands**:
   ```bash
   # Test specific Lua code execution
   nvim --headless -c 'lua print(vim.version())' -c 'quit' 2>&1
   
   # Verify plugin is loaded
   nvim --headless -c 'lua print(vim.inspect(require("lazy").plugins()))' -c 'quit' 2>&1
   
   # Check specific option
   nvim --headless -c 'lua print(vim.g.mapleader)' -c 'quit' 2>&1
   ```

6. **Run Health Checks Headlessly**:
   ```bash
   # Full health check
   nvim --headless +'checkhealth' +'quit' 2>&1 | tee /tmp/health-check.log
   
   # Specific plugin health check
   nvim --headless +'checkhealth lazy' +'quit' 2>&1
   nvim --headless +'checkhealth lsp' +'quit' 2>&1
   
   # Check for ERROR or WARNING in output
   if grep -q "ERROR" /tmp/health-check.log; then
     echo "✗ Health check found errors"
     grep "ERROR" /tmp/health-check.log
   else
     echo "✓ Health check passed"
   fi
   ```

7. **Validation Checklist (Headless)**:
   - [ ] `nvim --headless -c 'quit'` exits with code 0
   - [ ] `nvim --headless +'checkhealth lazy' +'quit'` shows no errors
   - [ ] `nvim --headless +'checkhealth' +'quit'` shows no critical errors
   - [ ] All regression tests in `tests/` still pass
   - [ ] Plugin appears in `:lua require("lazy").plugins()` output
   - [ ] Test specific functionality with Lua commands
   - [ ] No ERROR/WARN in health check output

8. **Cleanup After Testing**:
   ```bash
   # Clean up tmp/ disposable files
   rm ~/.config/nvim/tmp/test-*.lua
   
   # Clean up test logs
   rm /tmp/nvim-test.log /tmp/health-check.log
   
   # Keep tests/ directory and all regression tests
   # These should be version controlled and run regularly
   ```

#### Headless Testing Best Practices

**Always Use Headless Mode for Automation**:
```bash
# GOOD - Headless, verifiable
nvim --headless +'checkhealth' +'quit' 2>&1

# BAD - Requires interactive UI, not automatable
nvim -c 'checkhealth'
```

**Capture Output for Analysis**:
```bash
# Redirect stderr and stdout
nvim --headless -c 'messages' -c 'quit' 2>&1 | tee output.log

# Check exit codes
if [ $? -eq 0 ]; then echo "Success"; else echo "Failed"; fi

# Search for specific patterns
grep -i "error\|warn" output.log
```

**Test Incrementally**:
```bash
# Step 1: Config loads without errors
nvim --headless -c 'quit' 2>&1 && echo "✓ Config OK"

# Step 2: Plugins load
nvim --headless +'checkhealth lazy' +'quit' 2>&1 && echo "✓ Plugins OK"

# Step 3: Full health check
nvim --headless +'checkhealth' +'quit' 2>&1 && echo "✓ Health OK"

# Step 4: Regression tests
bash ~/.config/nvim/tests/run-all.sh && echo "✓ All tests pass"
```

#### Common Headless Test Scenarios

**1. Testing LazyVim Extra**:
```bash
# After editing lazyvim.json to add extra
# Verify JSON is valid
cat lazyvim.json | jq '.extras' || echo "Invalid JSON"

# Test Neovim loads
nvim --headless -c 'quit' 2>&1
echo "Exit code: $?"

# Run health check
nvim --headless +'checkhealth' +'quit' 2>&1 | tee /tmp/health.log
grep -i "error" /tmp/health.log && echo "✗ Errors found" || echo "✓ No errors"
```

**2. Testing Custom Plugin**:
```bash
# Create in tmp first
cat > ~/.config/nvim/tmp/test-plugin.lua << 'EOF'
return {
  "folke/flash.nvim",
  opts = {
    modes = { char = { enabled = false } }
  }
}
EOF

# Copy to lua/plugins/
cp ~/.config/nvim/tmp/test-plugin.lua ~/.config/nvim/lua/plugins/

# Test headlessly
nvim --headless +'Lazy sync' +'quit' 2>&1
nvim --headless +'checkhealth lazy' +'quit' 2>&1

# Verify plugin loaded
nvim --headless -c 'lua for name, _ in pairs(require("lazy").plugins()) do print(name) end' -c 'quit' 2>&1 | grep flash
```

**3. Testing Options**:
```bash
# Test option is set correctly
nvim --headless -c 'lua print("Leader: " .. vim.g.mapleader)' -c 'quit' 2>&1

# Test multiple options
nvim --headless -c 'lua print(vim.inspect({
  leader = vim.g.mapleader,
  localleader = vim.g.maplocalleader,
  picker = vim.g.lazyvim_picker,
  cmp = vim.g.lazyvim_cmp
}))' -c 'quit' 2>&1
```

**4. Testing Keymaps**:
```bash
# List all keymaps (outputs to check conflicts)
nvim --headless -c 'lua for _, map in pairs(vim.api.nvim_get_keymap("n")) do print(map.lhs, "->", map.rhs or "function") end' -c 'quit' 2>&1

# Check specific keymap exists
nvim --headless -c 'lua 
local maps = vim.api.nvim_get_keymap("n")
for _, map in pairs(maps) do 
  if map.lhs == "<leader>ff" then 
    print("Found: " .. map.lhs) 
  end 
end' -c 'quit' 2>&1
```

**5. Testing LSP Configuration**:
```bash
# Check LSP servers configured
nvim --headless -c 'lua print(vim.inspect(require("lspconfig").util.available_servers()))' -c 'quit' 2>&1

# Health check for LSP
nvim --headless +'checkhealth lsp' +'quit' 2>&1
```

#### Rollback Strategy

**If Headless Test Fails**:

1. **Examine Error Output**:
   ```bash
   # Run with verbose logging
   nvim --headless -V1 -c 'quit' 2>&1 | tee /tmp/nvim-verbose.log
   
   # Check for specific errors
   grep -i "error" /tmp/nvim-verbose.log
   ```

2. **Isolate the Problem**:
   ```bash
   # Test without the new plugin
   mv ~/.config/nvim/lua/plugins/test-plugin.lua ~/.config/nvim/tmp/
   nvim --headless -c 'quit' 2>&1
   echo "Exit code: $?"
   ```

3. **Revert Changes**:
   ```bash
   # Remove problematic plugin
   rm ~/.config/nvim/lua/plugins/problematic-plugin.lua
   
   # Verify config works again
   nvim --headless +'checkhealth' +'quit' 2>&1
   ```

4. **Plugin-Specific Rollback**:
   ```bash
   # Restore specific plugin version from lazy-lock.json
   nvim --headless +'Lazy restore' +'quit' 2>&1
   ```

5. **Ask User for Help**:
   - If unable to automatically fix, report the error to the user
   - Provide the error logs and what was attempted
   - Let user decide on next steps

#### Documentation After Testing

**Once headless tests pass**:

1. **Report results to user**:
   ```
   Test Results:
   - Config loads: ✓ (exit code 0)
   - Health check: ✓ (no errors)
   - Plugin loaded: ✓ (appears in lazy.plugins())
   - Regression tests: ✓ (all passed)
   - Functionality: ✓ (tested with: <command>)
   ```

2. **Clean up test artifacts**:
   ```bash
   rm ~/.config/nvim/tmp/test-*.lua
   rm /tmp/nvim-*.log
   ```

3. **Document significant changes** (in communication to user):
   - Note if follow-up is needed
   - Explain any complex configurations added
   - Highlight any architectural changes

4. **List files modified**:
   ```bash
   # Show user what was changed
   ls -lt ~/.config/nvim/lua/plugins/ | head -5
   ls -lt ~/.config/nvim/lua/config/ | head -5
   ```

### For Claude AI Assistants

**Before Making Any Changes**:

1. **Check LazyVim Extras First**: 
   - Browse catalog: https://lazyvim.org/extras
   - Check enabled: `cat lazyvim.json | jq '.extras'`
   - In Neovim: `:LazyExtras`
   - **If functionality exists as an extra, suggest enabling it instead of creating custom plugin**

2. **Consult Local Documentation First**:
   - Check Neovim core help files: `:help <topic>` or directly read files in `/home/linuxbrew/.linuxbrew/Cellar/neovim/<version>/share/nvim/runtime/doc/`
   - Check plugin documentation: `~/.local/share/nvim/lazy/<plugin>/README.md` and `doc/` directory
   - Review LazyVim official docs: https://lazyvim.org
   - **Only use MCP servers or web searches** when local docs don't have the answer
   - **Prefer local examples**: Check existing plugin configs in this repository before searching GitHub
   - **If using gh_grep MCP**: Only invoke when you need real-world GitHub examples not available locally

3. **Understand Current State**:
   - Read relevant config files from `lua/config/` and `lua/plugins/`
   - Check `lazyvim.json` for enabled extras
   - Review `lazy-lock.json` for exact plugin versions
   - Use discovery commands listed above

4. **When Uncertain, ASK**:
   - Don't assume user preferences
   - If multiple approaches exist (extra vs custom), ask for clarification
   - Explain tradeoffs between options

5. **Follow Configuration Hierarchy**:
   - **1st Priority**: Enable LazyVim extras (modify `lazyvim.json` via `:LazyExtras`)
   - **2nd Priority**: Override/extend existing configs (modify `lua/plugins/`)
   - **3rd Priority**: Core settings (modify `lua/config/`)
   - **NEVER**: Modify `~/.local/share/nvim/` without explicit approval

6. **ALWAYS Test Changes Headlessly**:
   - Use `tmp/` for disposable test files and experiments
   - Use `tests/` for permanent regression tests
   - Run headless validation: `nvim --headless -c 'quit' 2>&1`
   - Check health: `nvim --headless +'checkhealth' +'quit' 2>&1`
   - **Run regression test suite**: `bash ~/.config/nvim/tests/run-all.sh`
   - Verify exit codes (0 = success)
   - Search output for ERROR/WARNING keywords
   - Report test results to user before claiming success
   - **NEVER** assume edits work without headless verification
   - **CRITICAL**: All existing regression tests must still pass after your changes

7. **Plugin Management**:
   - Use lazy.nvim commands and understand LazyVim's structure
   - **Always check extras before suggesting custom plugins**
   - Prefer built-in LazyVim plugins (like Snacks) over alternatives
   - Avoid capability conflicts - don't duplicate functionality

8. **Code Formatting for Lua Files**:
   - **CRITICAL**: All Lua code edits MUST follow StyLua formatting rules
   - Configuration is defined in `stylua.toml` (indent: 2 spaces, quotes: double, column width: 120)
   - **After editing any Lua file**, run StyLua to ensure proper formatting:
     ```bash
     stylua --config-path ~/.config/nvim/stylua.toml <file-path>
     ```
   - **Verify formatting** before considering the edit complete:
     ```bash
     # Check if file needs formatting (exit code 1 = needs formatting)
     stylua --check --config-path ~/.config/nvim/stylua.toml <file-path>
     echo $?  # Should be 0 if properly formatted
     ```
   - **Common StyLua rules to follow**:
     - Use **double quotes** for strings (not single quotes): `"example"` not `'example'`
     - 2-space indentation (spaces, not tabs)
     - Max line length: 120 characters
     - Consistent spacing around operators and keywords
   - **When making edits**, prefer to manually follow StyLua conventions to avoid needing post-edit formatting
   - **If uncertain about formatting**, run StyLua on the file after editing to ensure compliance

9. **Code Examples & Documentation**:
   - Use Snacks picker in examples, NOT Telescope
   - Reference LazyVim docs: https://lazyvim.org
   - Check actual invocations from LazyVim source when uncertain

10. **Testing & Compatibility**:
   - Check `lazy-lock.json` for exact plugin versions
   - Verify changes don't conflict with LazyVim base configuration
   - Use `:checkhealth` to validate setup

11. **NEVER Manipulate Git**:
   - **DO NOT** run git commands (commit, add, push, pull, etc.)
   - **DO NOT** modify git state or history
   - **DO NOT** create commits or branches
   - Version control is the user's responsibility
   - Only read git status if explicitly needed for context

### Plugin Research & Documentation

**Dynamic Plugin Discovery**:
- Run `ls ~/.local/share/nvim/lazy/` to see currently installed plugins
- Each plugin directory contains source code and documentation
- Check `~/.local/share/nvim/lazy/<plugin>/README.md` for plugin documentation
- Look in `~/.local/share/nvim/lazy/<plugin>/doc/` for vim help files
- Examine `~/.local/share/nvim/lazy/<plugin>/lua/` for source code and examples

**Debugging & Logs**:
- Check `~/.cache/nvim/` for plugin-specific log files
- Use `~/.cache/nvim/luac/` for compiled Lua bytecode cache
- Mason logs and registry data in `~/.cache/nvim/mason-registry-update`
- Theme cache files (e.g., `tokyonight-*.json`) in `~/.cache/nvim/`

**State & Persistence**:
- Use `~/.local/state/nvim/` for session data, undo history, and plugin state
- Backup and undo files follow XDG specification based on `NVIM_APPNAME`

### Development Commands

**Basic Commands**:
- `:Lazy` - Plugin management interface
- `:LazyExtras` - LazyVim extras management
- `:Mason` - LSP/tool management
- `:checkhealth` - Diagnostic information
- `:Nerdy` - Icon/symbol picker

**Additional Debugging Commands**:
- `:lua =vim.version()` - Check Neovim version and build info
- `:lua =vim.fn.stdpath('data')` - Get data directory path
- `:lua =vim.fn.stdpath('config')` - Get config directory path
- `:lua =vim.fn.stdpath('cache')` - Get cache directory path
- `:echo $NVIM_APPNAME` - Check if using custom app name (affects paths)
- `Snacks.picker.keymaps()` - Search and inspect all key mappings
- `Snacks.picker.commands()` - Browse available commands
- `Snacks.picker.highlights()` - Inspect current highlight groups
- `:set runtimepath?` - Show where Neovim looks for files
- `:scriptnames` - List all loaded script files in load order
- `:messages` - View recent error/warning messages
- `:LspInfo` - LSP server status and information
- `:LspLog` - View LSP communication logs
- `:Lazy profile` - Plugin loading performance analysis

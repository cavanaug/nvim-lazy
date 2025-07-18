# Neovim Configuration Analysis - CLAUDE.md

## Overview

This is a comprehensive Neovim configuration built on top of **LazyVim**, featuring extensive language support, AI integrations, and custom workflows. The configuration has been migrated from AstroNvim v4+ to LazyVim and includes sophisticated plugin management and customizations.

## Architecture

### Plugin Management System

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast and modern plugin manager
- **Base Framework**: [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration framework built on lazy.nvim
- **Plugin Source**: `~/.local/share/nvim` - Location where all plugin source code is stored, this area is NEVER to be modified directly
- **Lock File**: `lazy-lock.json` - Pins exact plugin versions for reproducible builds

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
│   │   ├── keymaps.lua        # Custom keybindings (partially disabled)
│   │   ├── lazy.lua           # Lazy.nvim setup and plugin loading
│   │   └── options.lua        # Vim options and global settings
│   └── plugins/               # Plugin configurations
│       ├── colorscheme.lua    # Multiple theme configurations
│       ├── smart-splits.lua   # Window/pane navigation
│       ├── clipboard.lua      # Wayland clipboard integration
│       ├── terminal.lua       # Terminal integration
│       ├── various.lua        # Utility plugins
│       ├── which-key.lua      # Keybinding helper
│       ├── yaml-fix.lua       # YAML indentation fix
│       └── [other plugins...]
└── spell/                     # Custom spell checking dictionaries
    ├── en.utf-8.add           # Custom word additions
    └── en.utf-8.add.spl       # Compiled spell file
```

## Key Configuration Files

### Entry Point (`init.lua`)

- Simple bootstrapper that loads `config.lazy`
- Follows LazyVim's recommended minimal approach

### Core Configuration (`lua/config/`)

#### `lazy.lua` - Plugin Management

- Bootstraps lazy.nvim if not present
- Configures LazyVim as base with plugin imports from `plugins/` directory
- Disables some default vim plugins for performance
- Sets up plugin checking and performance optimizations

#### `options.lua` - Core Settings

**Key Features**:

- **Leader Keys**: `<Space>` (mapleader), `,` (maplocalleader)
- **XDG Compliance**: Backup/undo directories based on `NVIM_APPNAME`
- **Provider Disabling**: Disables unused providers (perl, node, ruby, python)
- **Advanced Display**: Cursorline, cursorcolumn, line numbers, custom fillchars
- **Folding**: UFO-compatible folding with custom markers
- **Backup Strategy**: Enables backup and undo files with XDG-compliant paths

#### `keymaps.lua` - Custom Keybindings

**Note**: Most keybindings are currently disabled (`return {}` guard)

- **Clipboard Integration**: Localleader mappings for system clipboard
- **Surround Shortcuts**: Muscle memory mappings for surround operations
- **Custom Functions**:
  - `<C-C>`: Smart buffer/window closing
  - `<C-e>`: Toggle window split orientation

#### `autocmds.lua` - Autocommands

- **Filetype Detection**: Custom patterns for `.envrc`, `.shrc`, `.avsc`, etc.
- **Spell Checking**: Auto-enable for markdown, text, gitcommit
- **Tmux Integration**: Auto-source tmux.conf on save
- **Help Window Management**: Smart help window positioning
- **Markdown Concealment**: Custom HTML comment handling

## LazyVim Extras Integration

The configuration heavily leverages LazyVim extras (defined in `lazyvim.json`):

### AI & Coding Assistance

- `copilot` & `copilot-chat` - GitHub Copilot integration
- `mini-comment`, `mini-surround` - Enhanced text manipulation
- `yanky` - Advanced yank/paste management

### Language Support

- **Languages**: Python, Rust, Go, TypeScript, C/C++, JSON, YAML, TOML, Markdown
- **DevOps**: Docker, Terraform, Ansible
- **Version Control**: Git integration

### Editor Enhancements

- `aerial` - Symbol outline
- `dial` - Enhanced increment/decrement
- `fzf` - Fuzzy finding
- `illuminate` - Symbol highlighting
- `inc-rename` - LSP renaming
- `overseer` - Task runner
- `snacks_picker` - Enhanced picker

### UI & Animation

- `mini-animate` - Smooth animations
- `mini-hipatterns` - Pattern highlighting

## Custom Plugin Configurations

### Theme Management (`colorscheme.lua`)

**Extensive Theme Collection**:

- **Active Themes**: Gruvbox, VSCode, Catppuccin, GitHub, Sonokai (current)
- **Theme Switching**: Themery plugin for dynamic switching (disabled)
- **Custom Styling**: Sonokai with custom diagnostic highlights

### Window Management (`smart-splits.lua`)

**Advanced Navigation**:

- **Movement**: `<C-hjkl>` for cursor movement between splits
- **Resizing**: `<A-hjkl>` for split resizing
- **Buffer Swapping**: `<leader><leader>hjkl` for buffer swapping
- **Tmux Integration**: Works with vim-tmux-navigator
- **Zellij Support**: Focus/tab switching integration

### Clipboard Integration (`clipboard.lua`)

**Wayland Support**:

- **System Integration**: wl-copy/wl-paste for Wayland
- **Yanky Plugin**: Enhanced yank history with 100-item ring
- **Sync Features**: Numbered registers and clipboard sync

### Terminal Integration (`terminal.lua`)

**ToggleTerm Configuration**:

- **Escape Sequences**: `<C-Space>` and `<Esc><Esc>` to exit terminal mode
- **Quick Toggle**: `<M-,>` for terminal toggle

## Development Workflows

### Code Formatting

- **Stylua**: Configured for 2-space indentation, 120-column width
- **Language-Specific**: Mason for LSP tool management
- **Auto-formatting**: Enabled via LazyVim's format-on-save

### Folding Strategy

- **UFO Plugin**: Advanced folding (currently disabled due to compatibility)
- **Custom Markers**: Fancy fold indicators and line count display
- **Fallback**: Standard indent-based folding for Neovim < 0.10

### Spell Checking

- **Custom Dictionary**: Personal words in `spell/en.utf-8.add`
- **Auto-enable**: For markdown, text, and git commit files
- **Technical Terms**: Includes development-related terminology

## Migration Notes

### From AstroNvim to LazyVim

**Current Status**: Partially migrated configuration

- **Keybindings**: Most custom keymaps are disabled pending review
- **Plugin Compatibility**: Some plugins marked as incompatible with current setup
- **Architecture**: Successfully transitioned to LazyVim's plugin structure

### Known Issues & Workarounds

1. **UFO Folding**: Disabled due to compatibility issues
2. **YAML Indentation**: TreeSitter indentation disabled for YAML files
3. **Python Providers**: Disabled due to errors in Neovim 0.10.1
4. **Mason Workaround**: Separate configuration file suggests installation issues

## Performance Optimizations

### Plugin Loading

- **Lazy Loading**: Most plugins load on demand
- **Disabled Plugins**: Removed unused vim plugins (gzip, tar, zip, etc.)
- **Startup Time**: Monitored via `startuptime` extra

### Resource Management

- **Provider Disabling**: Unused language providers disabled
- **Backup Strategy**: Efficient backup/undo with XDG compliance
- **Clipboard Caching**: Disabled for better performance

## AI Integration

### GitHub Copilot

- **Full Integration**: Both copilot and copilot-chat enabled
- **Completion Engine**: Auto-detection between nvim-cmp and blink.cmp
- **AI CMP**: Intelligent completion source selection

### CodeCompanion

- **Additional AI**: Secondary AI assistant integration
- **Chat Interface**: Alternative to Copilot Chat

## Customization Philosophy

### Configuration Approach

- **Base + Overrides**: LazyVim base with selective overrides
- **Muscle Memory**: Preserved familiar keybindings where possible
- **Gradual Migration**: Incremental transition from AstroNvim patterns

### Documentation Strategy

- **Inline Comments**: Extensive commenting in configuration files
- **Migration Notes**: README.md tracks migration progress and TODOs
- **Architecture Documentation**: This CLAUDE.md file for AI assistance

## Future Development

### Planned Improvements (from README.md backlog)

1. **Keybinding Finalization**: Complete keymap review and activation
2. **Folding Enhancement**: Resolve UFO compatibility issues
3. **Help Navigation**: Custom mappings for help file navigation
4. **Diffview Integration**: Fix productivity-blocking diffview issues
5. **Terminal Workflows**: Enhanced tmux/vim/WSL clipboard integration

### Learning Targets

- **Advanced Features**: Quickfix window, LSP navigation, Trouble plugin
- **Text Objects**: Mastery of vim text object manipulations
- **Plugin Ecosystem**: Ultimate-autopair, neoclip, lsp-colors, neoconf

## Working with This Configuration

### For Claude AI Assistants

1. **Plugin Management**: Use lazy.nvim commands, understand LazyVim structure
2. **Configuration Editing**: Focus on `lua/plugins/` for plugin-specific changes
3. **Options/Keymaps**: Modify `lua/config/` files for core behavior
4. **Testing**: Be aware of disabled features and migration status
5. **Compatibility**: Check lazy-lock.json for exact plugin versions

### Development Commands

- `:Lazy` - Plugin management interface
- `:LazyExtras` - LazyVim extras management
- `:Mason` - LSP/tool management
- `:checkhealth` - Diagnostic information
- `:Nerdy` - Icon/symbol picker

This configuration represents a sophisticated, performance-oriented Neovim setup optimized for development workflows with strong AI integration and cross-platform compatibility (especially Wayland/WSL environments).


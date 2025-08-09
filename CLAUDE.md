# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **portable developer environment configuration repository** ("dotfiles") designed for rapid, reproducible setup across machines, dev containers, and cloud-init automation. The repository provides a single-script automation solution that bootstraps complete development environments without user interaction.

## Core Architecture

### Primary Automation Script
- **`install.sh`** - The canonical installer (1044+ lines) with sophisticated execution context detection
- **Non-interactive/Headless**: All operations run without prompts, optimized for CI/CD and cloud-init
- **Multi-User Support**: Detects execution context (root/cloud-init vs regular user) and handles target user determination
- **Cross-Platform**: Supports Linux, macOS with platform-specific optimizations
- **Idempotent**: Safe to re-run; checks for existing installations before proceeding

### Environment Context Detection
The script automatically detects and adapts to:
- **Cloud-init execution** (running as root)
- **CI/CD environments** (GitHub Actions, GitLab CI)
- **Multi-user scenarios** with proper ownership management
- **Different shells** (bash/zsh) with version compatibility checks

### Error Handling and Logging
- **Comprehensive logging** with timestamps and structured format
- **Network retry logic** with exponential backoff
- **Trap-based error handling** with line number reporting
- **Exit codes**: 0=success, 1=general error, 2=network error, 3=filesystem error, 4=permission error

## Common Development Commands

### Installation Commands
```bash
# Standard installation for current user
./install.sh

# Cloud-init/automation installation for specific user  
./install.sh --cloud-init --user username
sudo DOTFILES_USER=targetuser ./install.sh

# Debug mode with verbose output
DEBUG=1 ./install.sh
bash -x install.sh

# Help and options
./install.sh --help
```

### Environment Variables
```bash
export DOTFILES_USER=username    # Override target user
export DOTFILES_HOME=/path/home  # Override home directory  
export DEBUG=1                   # Enable debug mode
export CI=true                   # Indicate CI/automation environment
```

## Configuration Management

### Dotfiles Managed
- **Shell configs**: `.zshrc`, `.bashrc`, `.p10k.zsh`
- **Development tools**: `.vimrc`, `.tmux.conf`, `.digrc`, `.act`, `.opencommit`
- **IDE settings**: VSCode settings, extensions, tasks
- **Claude Code**: Settings and MCP server configurations

### Plugin/Theme Ecosystem
- **Vim plugins**: airline, nerdtree, fzf, gitgutter, fugitive, terraform, polyglot
- **Zsh plugins**: autosuggestions, syntax-highlighting, conda-completion, tfenv, lsd-aliases
- **Oh My Posh**: Cross-shell prompt with Powerlevel10k theme and Meslo fonts

### Development Tools Installation
- **tfenv** - Terraform version manager with automatic latest version setup
- **lsd** - Modern ls replacement (Linux-specific)
- **z jump tool** - Fast directory navigation
- **Oh My Zsh** - Zsh framework with custom plugin configuration

## Platform-Specific Features

### Cloud/DevOps Integration
- **Azure CLI**: Auto-upgrade configuration and completion setup
- **PowerShell profiles**: Environment-aware installation (Azure vs standard)
- **Conda integration**: Automatic initialization if present
- **GitHub CLI**: Pager configuration for better UX

### VSCode Integration
- **Shell integration**: Automatic setup for both bash and zsh
- **Extensions management**: Curated extension list with dev container support
- **Settings inheritance**: Consistent configuration across environments
- **Terminal profiles**: tmux, pwsh, zsh profiles pre-configured

## Key Implementation Patterns

### User and Permission Management
```bash
# Cross-platform user validation
user_exists() { ... }

# Proper ownership setting in multi-user scenarios
set_ownership() {
    if [[ "$EUID" -eq 0 ]] && [[ "$SCRIPT_USER" != "$TARGET_USER" ]]; then
        chown "$TARGET_USER:$(id -gn "$TARGET_USER")" "$path"
    fi
}
```

### Idempotent Operations
```bash
# Example: PATH addition with deduplication
if ! grep -q "export PATH=.*\.local/bin" "$shellrc"; then
    add_to_shell_config "$shellrc" "$home_localbin_export" "export PATH=.*\.local/bin" "\$HOME/.local/bin to PATH"
fi
```

### Network Operations with Retry
```bash
# Network operation with exponential backoff
retry_network_operation curl -fsSL "$url" -o "$output"
```

## Advanced Configuration

### Claude Code MCP Integration
- **MCP server configuration**: Perplexity integration with API key management
- **Tool permissions**: Comprehensive allowlist for Claude Code operations
- **Settings inheritance**: Automatic deployment during installation

### Git and Version Control
- **Enhanced git operations**: Smart branch detection and fallback strategies
- **Plugin management**: Git-based plugin installation with update capabilities
- **Commit message formatting**: Conventional commits with gitmoji integration

### Shell Environment Optimization
- **PATH management**: Automatic addition of `$HOME/.local/bin` 
- **Shell integration**: VSCode shell integration for both bash and zsh
- **Theme configuration**: Agnoster theme with Oh My Posh integration
- **Completion systems**: Azure CLI and custom completion setup

## Development Workflows

### Adding New Tools/Configurations
1. **Follow existing patterns**: Use idempotent checks, proper logging, error handling
2. **Test cross-platform**: Ensure compatibility with Linux/macOS detection
3. **Handle ownership**: Use `set_ownership` for multi-user scenarios
4. **Add to appropriate sections**: Group related functionality together

### Debugging Installation Issues
1. **Enable debug mode**: `DEBUG=1 ./install.sh`
2. **Check logs**: Look for `[dotfiles install.sh]` entries
3. **Verify permissions**: Check ownership and file permissions
4. **Test network operations**: Retry with network debugging enabled

### Environment-Specific Customization
- **Azure environments**: Detected via `AZUREPS_HOST_ENVIRONMENT`
- **CI/CD systems**: Detected via `CI`, `GITHUB_ACTIONS`, `GITLAB_CI` variables
- **Container environments**: Dev container detection and optimization

## Security Considerations

### Safe Operations
- **Backup creation**: Automatic backup with timestamps before overwriting
- **Permission validation**: Strict permission checking before operations
- **Input sanitization**: Safe handling of user input and environment variables
- **Temporary file management**: Proper cleanup with trap handlers

### Multi-User Security
- **Privilege escalation**: Proper sudo usage for cross-user operations  
- **Ownership management**: Automatic ownership setting for target user files
- **Environment isolation**: Clean environment variable handling

## Integration Points

### External System Integration
- **Cloud-init compatibility**: Full support for automated cloud deployments
- **Container integration**: Dev container and Docker environment support
- **CI/CD pipelines**: GitHub Actions and GitLab CI compatibility
- **Package managers**: Integration with system package managers where needed

### Development Environment Integration
- **IDE support**: VSCode, Vim configuration management
- **Shell environments**: bash, zsh, PowerShell profile management
- **Terminal multiplexers**: tmux configuration and plugin management
- **Version managers**: tfenv, conda environment management
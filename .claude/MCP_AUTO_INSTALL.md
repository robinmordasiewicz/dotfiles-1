# MCP Server Auto-Installation

The SuperClaude dotfiles system now automatically installs and configures MCP (Model Context Protocol) servers during the dotfiles installation process.

## Features

### 🚀 **Automatic Installation**
- Detects environment context (Azure, development, git repository)
- Installs appropriate MCP servers based on detected conditions
- Configures Claude Code Desktop with comprehensive MCP server setup

### 🧠 **Intelligent Environment Detection**
- **Azure Environment**: Detects Azure CLI, environment variables, or `.azure` config
- **Development Environment**: Detects `package.json`, `.git`, `Dockerfile`, or `pyproject.toml`
- **Git Repository**: Detects `.git` directory or git repository context
- **API Keys**: Detects available API keys for services like Perplexity

### 📦 **MCP Servers Installed**

#### **Core Servers (Always Installed)**
- `memory` - Persistent memory and knowledge management
- `sequential-thinking` - Complex multi-step analysis and reasoning
- `mcp-installer` - Helper for managing additional MCP servers

#### **Development Environment**
- `context7` - Library documentation and code examples  
- `magic` - UI component generation and design systems

#### **Azure Environment**
- `microsoft-azure` - Azure resource management and operations
- `microsoft-learn` - Microsoft Learn documentation access

#### **Conditional Servers**
- `Perplexity` - AI-powered web search (requires `PERPLEXITY_API_KEY`)
- `terraform` - Infrastructure as Code via Docker (requires Docker)
- `tmux` - Terminal multiplexer integration

## Configuration Files

### **Primary Configuration**
- **`.claude/mcp.json`** - Comprehensive MCP server configuration (used if available)
- **`.claude/claude_desktop_config.json`** - Generated Claude Code configuration

### **Template Configurations**  
- **`.claude/mcp/servers.json`** - Detailed server specifications with install conditions
- **`.claude/mcp/config-template.json`** - Template for custom server configurations

## Installation Process

### **Automatic Installation**
```bash
./install.sh
# MCP servers are automatically detected and installed
```

### **Cloud-Init/Automation**
```bash
./install.sh --cloud-init --user targetuser
# Works with cloud-init and CI/CD environments
```

### **Environment Variables**
```bash
# Optional: Pre-configure API keys for enhanced functionality
export PERPLEXITY_API_KEY="your-api-key"
export AZURE_AUTH_METHOD="cli"

./install.sh
```

## Environment Detection Logic

### **Azure Environment Triggers**
```bash
# Any of these conditions triggers Azure MCP installation:
- $AZUREPS_HOST_ENVIRONMENT is set
- Azure CLI (`az`) command available
- ~/.azure directory exists
```

### **Development Environment Triggers**
```bash
# Any of these files triggers development MCP installation:
- package.json
- .git/config  
- Dockerfile
- pyproject.toml
```

### **Git Repository Triggers**
```bash
# Git-related MCP servers install when:
- .git directory exists
- `git rev-parse --git-dir` succeeds
```

## SuperClaude Framework Integration

### **Auto-Activation Patterns**
The installed MCP servers integrate seamlessly with SuperClaude's auto-activation system:

- **Context7** → Auto-activates for library documentation requests
- **Sequential** → Auto-activates for complex analysis (`--think`, `--think-hard`)  
- **Magic** → Auto-activates for UI component requests
- **Memory** → Always available for context retention
- **Azure** → Auto-activates in Azure environments

### **Command Enhancement**
Your existing SuperClaude commands get enhanced capabilities:
- `/analyze` → Uses Sequential for deep analysis
- `/build` → Uses Magic for UI builds, Context7 for patterns
- `/implement` → Uses Context7 for framework patterns
- `/improve` → Uses Sequential for systematic improvements

## Troubleshooting

### **Installation Issues**
```bash
# Enable debug mode for detailed logging
DEBUG=1 ./install.sh

# Check MCP server installation
npx @modelcontextprotocol/server-memory --version
```

### **Configuration Issues**
```bash
# Verify Claude Code configuration
cat ~/.claude/claude_desktop_config.json

# Check MCP server availability
ls -la ~/.claude/
```

### **Missing Dependencies**
- **npm** required for MCP server installation
- **uvx** recommended for Perplexity server (Python package manager)
- **Docker** required for Terraform server
- **jq** recommended for advanced configuration parsing

## Customization

### **Adding Custom Servers**
1. Edit `.claude/mcp/servers.json` to add new server definitions
2. Update install conditions as needed
3. Re-run `./install.sh` to apply changes

### **Environment-Specific Installation**
```bash
# Force specific environment detection
FORCE_AZURE_ENV=1 ./install.sh
FORCE_DEV_ENV=1 ./install.sh
```

### **Selective Installation**
The system is designed to gracefully handle missing dependencies and failed installations. Servers that can't be installed are logged as warnings but don't stop the overall installation.

## Integration with Existing Workflow

This enhancement maintains full compatibility with your existing dotfiles workflow:
- ✅ Idempotent operations (safe to re-run)
- ✅ Multi-user support (cloud-init compatible)  
- ✅ Cross-platform support (Linux/macOS)
- ✅ Proper ownership and permissions handling
- ✅ Comprehensive error handling and logging
- ✅ Follows existing installation patterns

The MCP auto-installation integrates seamlessly into your existing setup process and enhances your SuperClaude capabilities without requiring any changes to your current workflow.
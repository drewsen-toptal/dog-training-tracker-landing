# Claude Code Setup Instructions

This repository contains a complete backup of the Claude Code configuration, including all MCP servers, custom tools, credentials, and settings.

## Quick Start

1. **Extract this archive** to a location of your choice
2. **Install Claude Code** if not already installed
3. **Copy configuration files** to appropriate locations
4. **Install MCP servers** using the provided commands
5. **Configure credentials** with your API keys

## Prerequisites

- Node.js (v18+)
- Python 3.8+
- Git
- Claude Desktop or Claude Code CLI

## Configuration Files

### Claude Desktop Configuration
- **File**: `claude_desktop_config.json`
- **Location**: `~/Library/Application Support/Claude/` (macOS)
- **Backup**: This file is included in this repository

### MCP Servers Configuration
- **File**: `mcp-servers.json`
- **Contains**: Complete list of all configured MCP servers with connection details

## MCP Servers Overview

### Working MCP Servers (18 connected)

1. **mobile-mcp** - Mobile device testing and automation
2. **xcodebuildmcp** - Xcode build tools and iOS development
3. **filesystem** - File system operations
4. **playwright** - Browser automation and web scraping
5. **fetch** - HTTP requests
6. **puppeteer** - Alternative browser automation
7. **vercel** - Vercel deployment management
8. **yahoo-finance** - Financial market data
9. **claude-historian** - Conversation history tracking
10. **financial-datasets** - Advanced financial data
11. **optionsflow** - Options trading analysis (custom)
12. **github** - GitHub repository management
13. **brave-search** - Web search via Brave API
14. **pdf-reader** - PDF extraction and analysis
15. **firecrawl** - Advanced web crawling
16. **cloudflare** - Cloudflare Workers management
17. **shadcn** - shadcn/ui component integration
18. **tailwindcss** - TailwindCSS utilities

### Failed/Offline MCP Servers (5)

1. **chrome-devtools** - Chrome integration (requires troubleshooting)
2. **authenticator-mcp** - Authentication (may need reinstall)
3. **authn8** - Auth services (may need reinstall)
4. **figma** - Figma integration (may need credentials)
5. **ibkr** - Interactive Brokers (requires running service on localhost:5002)

## Installation Steps

### 1. Restore Claude Desktop Configuration

```bash
# Backup existing config (if any)
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json.backup

# Copy the backed up configuration
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/
```

### 2. Install Custom MCP Servers

```bash
# Create MCP servers directory if it doesn't exist
mkdir -p ~/mcp-servers

# Copy custom MCP servers
cp -r custom-mcp-servers/mcp-servers/* ~/mcp-servers/
cp -r custom-mcp-servers/optionsflow ~/mcp-optionsflow/
```

### 3. Install Node.js MCP Dependencies

Most MCP servers are installed automatically via `npx`. No manual installation needed for:
- playwright, puppeteer, fetch, filesystem, github, brave-search, pdf-reader, firecrawl, shadcn, tailwindcss

### 4. Setup Python Environment (for optionsflow)

```bash
cd ~/mcp-optionsflow
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 5. Configure Credentials

```bash
# Copy the example credentials file
cp credentials.env.example credentials.env

# Edit with your actual credentials
nano credentials.env
```

Required credentials:
- **VERCEL_API_KEY**: Get from Vercel dashboard
- **FINANCIAL_DATASETS_API_KEY**: Get from financialdatasets.ai
- **CLOUDFLARE_ACCOUNT_ID**: Get from Cloudflare dashboard
- **BRAVE_SEARCH_API_KEY**: Get from Brave Search API

### 6. Verify Installation

```bash
# Run Claude Code doctor to verify setup
claude doctor

# List MCP servers
claude mcp list
```

## Custom MCP Servers Details

### XcodeBuildMCP
- **Location**: `~/mcp-servers/XcodeBuildMCP`
- **Purpose**: Xcode project management, iOS builds
- **Build**: Node.js based, pre-built

### iOS Simulator MCP
- **Location**: `~/mcp-servers/ios-simulator-mcp`
- **Purpose**: iOS simulator control and testing
- **Build**: Node.js based, pre-built

### Cupertino
- **Location**: `~/mcp-servers/cupertino`
- **Purpose**: Apple platform development tools
- **Build**: Swift binary (pre-compiled)

### SwiftLens
- **Location**: `~/mcp-servers/swiftlens`
- **Purpose**: Swift code analysis
- **Build**: Python based with virtual environment

### OptionsFlow (Custom Trading Tool)
- **Location**: `~/mcp-optionsflow`
- **Purpose**: Options market flow analysis
- **Build**: Custom Python script with dependencies

## Troubleshooting

### MCP Server Won't Connect

1. Check the server is installed:
   ```bash
   which npx
   node --version
   ```

2. Try reinstalling the server:
   ```bash
   claude mcp remove <server-name>
   claude mcp add <server-name> <command>
   ```

3. Check logs:
   ```bash
   tail -f ~/.config/claude/logs/claude.log
   ```

### Python MCP Servers Failing

1. Ensure Python 3.8+ is installed:
   ```bash
   python3 --version
   ```

2. Recreate virtual environment:
   ```bash
   cd ~/mcp-optionsflow
   rm -rf .venv
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

### IBKR Not Connecting

The Interactive Brokers MCP requires a running IBKR Gateway or TWS:
1. Install IBKR Gateway
2. Enable API connections
3. Start the gateway on port 5002

## Permissions & Auto-Approval

This configuration has **full auto-approval** enabled for:
- All commands
- All tools (Bash, Read, Write, Edit, etc.)
- All file operations
- All network operations
- All process execution

**Security Note**: This configuration trusts Claude Code completely. Review `claude_desktop_config.json` if you want to restrict permissions.

## Next Steps

After setup, you can:

1. **Verify all servers are running**:
   ```bash
   claude mcp list
   ```

2. **Test a simple operation**:
   ```bash
   # Test file operations
   claude "create a test file"

   # Test web search
   claude "search for latest AI news"

   # Test financial data
   claude "get AAPL stock price"
   ```

3. **Resume your work** - All configurations are restored, you can continue from where you left off

## Model Configuration

Current model: **Claude Sonnet 4.5** (claude-sonnet-4-5-20250929)

To switch to Opus 4.5 (deeper reasoning):
```bash
claude config set model claude-opus-4-5
# Restart Claude Code after changing model
```

## Support

If you encounter issues:
1. Check `claude doctor` output
2. Review MCP server logs
3. Verify credentials in `credentials.env`
4. Ensure all prerequisites are installed

## File Structure

```
claude-code-backup/
├── README.md (this file)
├── SETUP_INSTRUCTIONS.md
├── CURRENT_STATE.md
├── mcp-servers.json
├── credentials.env.example
├── claude_desktop_config.json
└── custom-mcp-servers/
    ├── optionsflow/
    └── mcp-servers/
        ├── XcodeBuildMCP/
        ├── ios-simulator-mcp/
        ├── cupertino/
        ├── swiftlens/
        └── SwiftAgents/
```

---

**Last Updated**: 2025-12-28
**Claude Code Version**: 3.0.1
**Platform**: macOS (Darwin 25.1.0)

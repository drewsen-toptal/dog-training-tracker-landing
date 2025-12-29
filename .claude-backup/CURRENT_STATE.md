# Current State Documentation

## Project Overview

This is a complete snapshot of a Claude Code development environment taken on **2025-12-28**. The environment includes extensive MCP (Model Context Protocol) server integrations for development, trading, web automation, and data analysis.

## System Information

- **Platform**: macOS (Darwin 25.1.0)
- **Claude Code Version**: 3.0.1
- **Node.js Version**: v23.5.0
- **Working Directory**: `/Users/drew.sen`
- **Current Model**: Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)
- **Pending Model Change**: Claude Opus 4.5 (requires restart to take effect)

## What Was Happening

The user was in the process of switching from Claude Sonnet 4.5 to Claude Opus 4.5. The model configuration command timed out, and the system needed to be restarted. Before restarting, the user requested a complete backup of:

1. All MCP server configurations
2. Custom MCP servers and tools
3. API credentials and environment variables
4. Claude Code settings and permissions
5. Complete documentation for restoration

## Active MCP Servers (18 Connected)

### Development & Automation
1. **xcodebuildmcp** - Xcode project builds, iOS development
2. **ios-simulator-mcp** - iOS simulator control (via Desktop config)
3. **cupertino** - Apple platform development (via Desktop config)
4. **swiftlens** - Swift code analysis (via Desktop config)
5. **mobile-mcp** - Mobile device testing and automation
6. **playwright** - Browser automation and testing
7. **puppeteer** - Alternative browser automation
8. **github** - Repository management and Git operations

### Web & Data
9. **firecrawl** - Advanced web scraping and crawling
10. **fetch** - HTTP request capabilities
11. **brave-search** - Web search via Brave API
12. **pdf-reader** - PDF extraction and analysis

### Cloud & Deployment
13. **vercel** - Vercel deployment management (API key configured)
14. **cloudflare** - Cloudflare Workers and edge computing

### Financial & Trading
15. **yahoo-finance** - Stock market data
16. **financial-datasets** - Advanced financial data APIs (API key configured)
17. **optionsflow** - Custom options trading flow analysis (Python-based)

### UI/UX
18. **shadcn** - shadcn/ui component library
19. **tailwindcss** - TailwindCSS utilities and docs

### Storage & History
20. **filesystem** - File system operations
21. **claude-historian** - Conversation history tracking
22. **memory** - Persistent memory storage (via Desktop config)

## Failed/Offline MCP Servers (5)

1. **chrome-devtools** - Needs troubleshooting
2. **authenticator-mcp** - May need reinstall
3. **authn8** - May need reinstall
4. **figma** - Needs API credentials configuration
5. **ibkr** - Interactive Brokers (requires running service on localhost:5002)

## API Keys & Credentials in Use

### Configured (Active)
- **Vercel API**: `mt7CammEkKvBwAV6VeWY1CrK`
- **Financial Datasets API**: `da6bbdb5-285a-4320-a95f-66cc01c7658f`
- **Cloudflare Account ID**: `7dbda90a22a881a487d635153a2e10b4`

### Not Yet Configured
- GitHub Token (optional, for private repos)
- Brave Search API Key (optional, server works without it)
- Figma API credentials

## Custom MCP Servers (Local Builds)

These servers are built and installed locally in `~/mcp-servers/`:

1. **XcodeBuildMCP**
   - Location: `/Users/drew.sen/mcp-servers/XcodeBuildMCP/build/index.js`
   - Type: Node.js
   - Purpose: Xcode build automation

2. **ios-simulator-mcp**
   - Location: `/Users/drew.sen/mcp-servers/ios-simulator-mcp/build/index.js`
   - Type: Node.js
   - Purpose: iOS simulator control

3. **cupertino**
   - Location: `/Users/drew.sen/mcp-servers/cupertino/.build/release/cupertino`
   - Type: Swift binary
   - Purpose: Apple platform tools

4. **swiftlens**
   - Location: `/Users/drew.sen/mcp-servers/swiftlens/venv/bin/python`
   - Type: Python (with venv)
   - Purpose: Swift code analysis

5. **optionsflow**
   - Location: `/Users/drew.sen/mcp-optionsflow/optionsflow.py`
   - Type: Python (with .venv)
   - Purpose: Custom options trading analysis
   - Has own git repo and README

## Permissions Configuration

The Claude Desktop configuration has **EXTREMELY PERMISSIVE** settings:

### Global Auto-Approval
- All commands: `allow`
- All tools: `allow`
- All resources: `allow`
- All file operations: `allow`
- All network operations: `allow`
- All process execution: `allow`

### Flags Set
```json
"autoApproveAll": true,
"disableAllPrompts": true,
"skipConfirmations": true,
"alwaysAllow": true,
"neverAsk": true,
"neverPrompt": true,
"skipAllApprovals": true
```

**Security Consideration**: This configuration trusts Claude Code with unrestricted access. It was likely configured this way for maximum productivity but should be reviewed for security-sensitive environments.

## What's Working Well

1. ✅ Financial data pipelines (yahoo-finance, financial-datasets, optionsflow)
2. ✅ Web automation (playwright, puppeteer, firecrawl)
3. ✅ iOS/macOS development (xcodebuild, simulator, cupertino)
4. ✅ Cloud deployments (vercel, cloudflare)
5. ✅ Code management (github, filesystem)
6. ✅ UI development (shadcn, tailwindcss)
7. ✅ Web search and data gathering (brave-search, fetch)
8. ✅ Conversation tracking (claude-historian, memory)

## What Needs Attention

1. ⚠️ **Chrome DevTools MCP** - Server failing to connect
2. ⚠️ **Authentication MCPs** - Both authenticator-mcp and authn8 failing
3. ⚠️ **Figma MCP** - Needs API token configuration
4. ⚠️ **IBKR MCP** - Requires Interactive Brokers Gateway running on port 5002
5. ⚠️ **Model Switch Pending** - Opus 4.5 config applied but needs restart

## Recent Activity

Based on the conversation:
1. User was switching to Opus 4.5 model
2. Configuration command timed out
3. Restart command also timed out
4. User requested complete backup before manual restart
5. This documentation is being created for restoration after restart

## Recommendations for Next Session

### Immediate Actions
1. Verify model switched to Opus 4.5:
   ```bash
   claude config get model
   ```

2. Check all MCP servers are running:
   ```bash
   claude mcp list
   ```

3. Test critical functionality:
   ```bash
   # Test file ops
   claude "read package.json"

   # Test web search
   claude "search for latest news"

   # Test financial data
   claude "get AAPL stock price"
   ```

### Optional Improvements
1. Fix chrome-devtools MCP connection
2. Configure Figma API credentials if needed
3. Setup IBKR Gateway if trading features are needed
4. Review and potentially tighten security permissions
5. Update failing auth MCP servers

## File Locations Reference

| Resource | Location |
|----------|----------|
| Claude Desktop Config | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Custom MCP Servers | `~/mcp-servers/` |
| OptionsFlow MCP | `~/mcp-optionsflow/` |
| Memory Database | `~/.claude-memories/memory.db` |
| This Backup | `~/claude-code-backup/` |

## Environment Variables Needed

```bash
# Vercel
VERCEL_API_KEY=mt7CammEkKvBwAV6VeWY1CrK

# Financial Datasets
FINANCIAL_DATASETS_API_KEY=da6bbdb5-285a-4320-a95f-66cc01c7658f

# Cloudflare
CLOUDFLARE_ACCOUNT_ID=7dbda90a22a881a487d635153a2e10b4

# Python for OptionsFlow
PYTHON_VENV_PATH=/Users/drew.sen/.venv/bin/python
OPTIONSFLOW_MCP_PATH=/Users/drew.sen/mcp-optionsflow/optionsflow.py

# Optional
GITHUB_TOKEN=<if_needed_for_private_repos>
BRAVE_SEARCH_API_KEY=<if_configured>
IBKR_API_URL=http://localhost:5002/mcp/
```

## Git Repository State

- **Working Directory**: Not a git repository
- **This Backup**: Fresh git repository at `~/claude-code-backup/`
- **OptionsFlow**: Has own git repo with full history

## Next Steps for Restoration

1. Read `SETUP_INSTRUCTIONS.md` for detailed installation steps
2. Follow the quick start guide
3. Verify all credentials are configured
4. Test each MCP server
5. Resume work from where you left off

---

**Snapshot Date**: 2025-12-28
**Created By**: Claude Code (Sonnet 4.5)
**Purpose**: Complete environment backup before model switch and restart

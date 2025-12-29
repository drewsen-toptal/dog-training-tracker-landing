# Claude Code Environment Backup

Complete backup of Claude Code environment with 18+ active MCP servers, custom tools, and configurations.

**Created**: 2025-12-28
**Platform**: macOS (Darwin 25.1.0)
**Claude Code**: v3.0.1
**Model**: Claude Sonnet 4.5 → Claude Opus 4.5 (pending)

## 📦 What's Included

- ✅ Complete Claude Desktop configuration with auto-approval settings
- ✅ 23 MCP server configurations (18 working, 5 offline)
- ✅ 5 custom-built MCP servers (Xcode, iOS Simulator, Cupertino, SwiftLens, OptionsFlow)
- ✅ API credentials and environment variables (examples provided)
- ✅ Full setup and restoration instructions
- ✅ Current state documentation
- ✅ All source code for custom MCP servers

## 🚀 Quick Start

1. **Extract this archive**
2. **Read** `SETUP_INSTRUCTIONS.md` for detailed installation steps
3. **Check** `CURRENT_STATE.md` to understand the environment state
4. **Copy** `claude_desktop_config.json` to `~/Library/Application Support/Claude/`
5. **Copy** custom MCP servers to `~/mcp-servers/` and `~/mcp-optionsflow/`
6. **Configure** your API keys in `credentials.env`
7. **Verify** with `claude doctor` and `claude mcp list`

## 📋 Documentation

| File | Purpose |
|------|---------|
| **README.md** | This file - quick overview |
| **SETUP_INSTRUCTIONS.md** | Detailed installation and setup guide |
| **CURRENT_STATE.md** | Complete snapshot of environment state |
| **mcp-servers.json** | All MCP server configurations and status |
| **credentials.env.example** | Template for API keys and secrets |
| **claude_desktop_config.json** | Claude Desktop configuration file |

## 🔧 MCP Servers Included

### Development (8)
- xcodebuildmcp, ios-simulator-mcp, cupertino, swiftlens
- mobile-mcp, github, filesystem, memory

### Web & Automation (4)
- playwright, puppeteer, firecrawl, fetch

### Financial & Trading (3)
- yahoo-finance, financial-datasets, optionsflow

### Cloud & Deployment (2)
- vercel, cloudflare

### UI/UX & Tools (6)
- shadcn, tailwindcss, brave-search, pdf-reader, claude-historian

### Offline (5)
- chrome-devtools, authenticator-mcp, authn8, figma, ibkr

## 🔑 Required Credentials

You'll need API keys for:
- **Vercel** (deployment management)
- **Financial Datasets** (market data)
- **Cloudflare** (Workers/edge computing)

Optional:
- GitHub token (for private repos)
- Brave Search API key
- Figma API credentials
- IBKR Gateway (for trading)

## 📁 Directory Structure

```
claude-code-backup/
├── README.md                      # This file
├── SETUP_INSTRUCTIONS.md          # Full setup guide
├── CURRENT_STATE.md               # Environment snapshot
├── mcp-servers.json               # MCP server configs
├── credentials.env.example        # Credential template
├── claude_desktop_config.json     # Claude config
└── custom-mcp-servers/
    ├── optionsflow/              # Options trading analysis
    └── mcp-servers/
        ├── XcodeBuildMCP/        # Xcode build tools
        ├── ios-simulator-mcp/    # iOS simulator control
        ├── cupertino/            # Apple platform tools
        ├── swiftlens/            # Swift code analysis
        └── SwiftAgents/          # Swift agent framework
```

## ⚡ Features

### Auto-Approval Configuration
This configuration has **full auto-approval** enabled for maximum productivity:
- All commands auto-approved
- All file operations permitted
- All network access allowed
- No confirmation prompts

**⚠️ Security Note**: Review permissions if using in sensitive environments.

### Custom Tools

**OptionsFlow** - Custom Python-based options trading analysis tool with:
- Real-time options flow analysis
- Market data integration
- Trading signal generation

**XcodeBuildMCP** - Complete Xcode automation:
- Project builds
- Simulator management
- iOS app deployment

**Cupertino** - Swift-based Apple development tools
**SwiftLens** - Swift code analysis and insights

## 🔍 Troubleshooting

### MCP Server Won't Connect
```bash
claude mcp remove <server-name>
claude mcp add <server-name> <command>
```

### Python Servers Failing
```bash
cd ~/mcp-optionsflow
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Verify Installation
```bash
claude doctor
claude mcp list
```

## 📊 System Requirements

- **OS**: macOS (Linux/Windows with modifications)
- **Node.js**: v18+
- **Python**: 3.8+
- **Git**: Latest version
- **Claude Code**: 3.0+

## 🎯 Use Cases

This environment is configured for:
- **iOS/macOS Development** - Full Xcode integration
- **Trading & Finance** - Real-time market data and analysis
- **Web Automation** - Scraping, testing, data collection
- **Cloud Deployment** - Vercel, Cloudflare edge computing
- **UI Development** - shadcn/ui, TailwindCSS integration
- **Research & Analysis** - Web search, PDF extraction, data processing

## 📝 Notes

- **Model Pending**: Configuration set to Opus 4.5, requires restart to activate
- **Git Ready**: This backup is a git repository - commit and push as needed
- **Portable**: Can be restored on any compatible system
- **Complete**: All dependencies and source code included

## 🔄 Restoration Steps

1. Extract archive
2. Follow `SETUP_INSTRUCTIONS.md`
3. Copy config files to system locations
4. Install dependencies
5. Configure credentials
6. Run `claude doctor`
7. Resume work

## 📞 Support

For issues:
1. Check `claude doctor` output
2. Review `CURRENT_STATE.md` for known issues
3. Check MCP server logs
4. Verify all credentials configured

## 📅 Version History

- **v1.0** - 2025-12-28 - Initial backup before Opus 4.5 model switch

---

**Ready to restore?** Start with `SETUP_INSTRUCTIONS.md`

**Want to understand the state?** Read `CURRENT_STATE.md`

**Need credentials?** See `credentials.env.example`

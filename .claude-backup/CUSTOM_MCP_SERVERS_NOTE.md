# Custom MCP Servers Note

Due to GitHub repository size limitations, the full source code for the following custom MCP servers is NOT included in this repository:

## Excluded MCP Servers (Large Source Code)

1. **XcodeBuildMCP** (~15,000 files)
   - Location: `~/mcp-servers/XcodeBuildMCP/`
   - Repository: https://github.com/xcodebuildmcp/xcodebuildmcp

2. **ios-simulator-mcp**
   - Location: `~/mcp-servers/ios-simulator-mcp/`

3. **cupertino**
   - Location: `~/mcp-servers/cupertino/`

4. **swiftlens**
   - Location: `~/mcp-servers/swiftlens/`

## What IS Included

✅ Complete configuration in `claude_desktop_config.json`
✅ Server definitions in `mcp-servers.json`
✅ Installation instructions in `SETUP_INSTRUCTIONS.md`
✅ OptionsFlow custom MCP (smaller, custom-built)
✅ SwiftAgents documentation

## Full Backup Location

The complete backup with all MCP server source code is available at:
- **Archive**: `~/claude-code-backup-20251228.tar.gz` (369 MB)
- **Directory**: `~/claude-code-backup/`
- **Git Repo**: Local repository with full history

To restore the full environment including all custom MCP servers, use the archive file.

## Restoring Custom MCP Servers

The custom MCP servers can be reinstalled using the configuration:

```bash
# Configuration already includes paths to local builds
# Just ensure the servers are built at:
# - ~/mcp-servers/XcodeBuildMCP/
# - ~/mcp-servers/ios-simulator-mcp/
# - ~/mcp-servers/cupertino/
# - ~/mcp-servers/swiftlens/

# Or install from their respective repositories
```

For the complete backup with all source code, extract:
```bash
tar -xzf ~/claude-code-backup-20251228.tar.gz
```

---

**Note**: This repository focuses on the dog training tracker landing page project. The Claude Code backup is stored in `.claude-backup/` as supplementary documentation for development environment restoration.

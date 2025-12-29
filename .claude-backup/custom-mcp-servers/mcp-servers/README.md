# iOS/Swift MCP Servers Configuration

All MCP servers have been successfully installed and configured with full permissions enabled in Claude Desktop.

## Installed MCP Servers

### 1. XcodeBuildMCP
- **Location**: `/Users/drew.sen/mcp-servers/XcodeBuildMCP`
- **Purpose**: Xcode project management, building, and simulator management
- **Repository**: https://github.com/cameroncooke/XcodeBuildMCP

### 2. iOS Simulator MCP
- **Location**: `/Users/drew.sen/mcp-servers/ios-simulator-mcp`
- **Purpose**: iOS simulator control and management
- **Repository**: https://github.com/joshuayoes/ios-simulator-mcp

### 3. Cupertino
- **Location**: `/Users/drew.sen/mcp-servers/cupertino`
- **Binary**: `/usr/local/bin/cupertino`
- **Purpose**: Apple documentation crawler and search
- **Repository**: https://github.com/mihaelamj/cupertino

### 4. SwiftLens
- **Location**: `/Users/drew.sen/mcp-servers/swiftlens`
- **Purpose**: Semantic-level Swift code analysis using SourceKit-LSP
- **Repository**: https://github.com/swiftlens/swiftlens
- **Note**: Uses Python virtual environment at `venv/`

### 5. SwiftAgents
- **Location**: `/Users/drew.sen/mcp-servers/SwiftAgents`
- **Purpose**: Best practices and guidelines for AI-generated Swift code
- **Repository**: https://github.com/twostraws/SwiftAgents
- **Note**: This is not an MCP server but a set of guidelines in AGENTS.md

## Configuration

The MCP configuration file is located at:
`~/Library/Application Support/Claude/claude_desktop_config.json`

All permissions have been enabled with `autoApprovalSettings` set to allow all commands and tools without prompting.

## Usage

1. **Restart Claude Desktop** to load the new MCP servers
2. The MCP servers will be automatically available in your Claude sessions
3. Claude will not ask for permission before executing commands (all permissions are pre-approved)

## Troubleshooting

If any MCP server doesn't work:

1. Check the logs in Claude Desktop
2. For XcodeBuildMCP: Run `cd ~/mcp-servers/XcodeBuildMCP && npm run doctor`
3. For Cupertino: Run `cupertino --version` to verify installation
4. For SwiftLens: Activate venv first: `cd ~/mcp-servers/swiftlens && source venv/bin/activate`

## Updating

To update any MCP server:
```bash
cd ~/mcp-servers/<server-name>
git pull
# Then rebuild/reinstall as needed
```

For npm-based servers (XcodeBuildMCP, ios-simulator-mcp):
```bash
npm install && npm run build
```

For Cupertino:
```bash
make update
```

For SwiftLens:
```bash
source venv/bin/activate && pip install -e . --upgrade
```
# ⚡ Quick Start Guide

Get your Claude Code environment restored in **5 minutes**.

## Step 1: Extract Archive (30 seconds)

```bash
# Extract the archive
tar -xzf claude-code-backup-20251228.tar.gz

# Navigate to directory
cd claude-code-backup
```

## Step 2: Copy Config Files (30 seconds)

```bash
# Backup existing config (optional)
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json.old

# Copy Claude Desktop config
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/

# Copy custom MCP servers
cp -r custom-mcp-servers/mcp-servers/* ~/mcp-servers/ 2>/dev/null || mkdir -p ~/mcp-servers && cp -r custom-mcp-servers/mcp-servers/* ~/mcp-servers/

# Copy OptionsFlow MCP
cp -r custom-mcp-servers/optionsflow ~/mcp-optionsflow/
```

## Step 3: Setup Python MCP (1 minute)

```bash
# Setup OptionsFlow
cd ~/mcp-optionsflow
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
deactivate
```

## Step 4: Configure Credentials (2 minutes)

```bash
# Copy template
cp credentials.env.example credentials.env

# Edit with your keys
nano credentials.env
```

Add your API keys:
- `VERCEL_API_KEY` - Get from https://vercel.com/account/tokens
- `FINANCIAL_DATASETS_API_KEY` - Get from https://financialdatasets.ai
- `CLOUDFLARE_ACCOUNT_ID` - Get from Cloudflare dashboard

## Step 5: Verify Installation (1 minute)

```bash
# Restart Claude Code (required!)
# Exit current session and start new one

# Then verify
claude doctor
claude mcp list
```

## ✅ You're Done!

Your environment is restored with:
- ✅ 18 working MCP servers
- ✅ 5 custom-built tools
- ✅ All configurations
- ✅ Full auto-approval settings

## 🧪 Test It

```bash
# Test file operations
claude "create a test.txt file with hello world"

# Test web search
claude "search for latest AI news"

# Test financial data
claude "get current AAPL stock price"

# Test GitHub
claude "list my recent commits"
```

## 🔧 Troubleshooting

### MCP Server Not Connecting?

```bash
claude mcp remove <server-name>
claude mcp list  # Verify it's removed
# Restart Claude Code
```

### Python Errors?

```bash
cd ~/mcp-optionsflow
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Model Not Opus 4.5?

```bash
claude config get model
# Should show: claude-opus-4-5

# If not:
claude config set model claude-opus-4-5
# Restart Claude Code
```

## 📚 Need More Help?

- **Full Guide**: Read `SETUP_INSTRUCTIONS.md`
- **Understanding State**: Read `CURRENT_STATE.md`
- **API Keys**: Check `credentials.env.example`
- **Project Info**: See `README.md`

## 🚨 Common Issues

| Issue | Fix |
|-------|-----|
| "MCP server not found" | Run setup from Step 2 |
| "Permission denied" | Check file permissions, run with proper user |
| "Module not found" (Python) | Reinstall venv (Step 3) |
| "API key invalid" | Double-check credentials (Step 4) |
| Still on Sonnet 4.5 | Set model and restart Claude Code |

## 💡 Pro Tips

1. **Restart Required**: Always restart Claude Code after:
   - Copying configs
   - Changing model
   - Adding/removing MCP servers

2. **Check Status**: Run `claude mcp list` regularly to verify connections

3. **Update Servers**: Most servers auto-update via npx, but custom ones need manual updates

4. **Security**: The config has full auto-approval. Review `claude_desktop_config.json` if you need restrictions.

---

**Time to restore**: ~5 minutes
**Difficulty**: Easy
**Requirements**: Node.js, Python 3.8+, basic terminal knowledge

Ready for the full documentation? → `SETUP_INSTRUCTIONS.md`

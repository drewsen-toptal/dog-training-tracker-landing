# New Machine Setup Guide

**Quick Start for New Claude Session on Different Machine**

This guide helps you clone the repository and restore the complete development environment (Claude Code + MCP servers + landing page project) on a new machine.

---

## 🚀 Quick Setup (5-10 minutes)

### Step 1: Clone the Repository

```bash
# Clone the dog training tracker landing page repository
git clone https://github.com/drewsen-toptal/dog-training-tracker-landing.git
cd dog-training-tracker-landing
```

### Step 2: Install Prerequisites

```bash
# Check Node.js (v18+)
node --version

# Check Python (3.8+)
python3 --version

# Install if missing:
# macOS: brew install node python3
# Linux: apt-get install nodejs python3
```

### Step 3: Install Landing Page Dependencies

```bash
# Install Next.js project dependencies
npm install

# Start development server to verify
npm run dev
# Open http://localhost:3000
```

### Step 4: Restore Claude Code Environment

```bash
# Navigate to Claude backup documentation
cd .claude-backup

# Read the quick start guide
cat QUICK_START.md

# Copy Claude Desktop configuration
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/

# Create MCP servers directory
mkdir -p ~/mcp-servers

# Copy OptionsFlow MCP
cp -r custom-mcp-servers/optionsflow ~/mcp-optionsflow/
cd ~/mcp-optionsflow
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
deactivate
```

### Step 5: Configure API Credentials

```bash
cd ~/dog-training-tracker-landing/.claude-backup

# Copy credential template
cp credentials.env.example credentials.env

# Edit with your API keys
nano credentials.env
# or
code credentials.env
```

Required API keys:
- **VERCEL_API_KEY** - Get from https://vercel.com/account/tokens
- **FINANCIAL_DATASETS_API_KEY** - Get from https://financialdatasets.ai
- **CLOUDFLARE_ACCOUNT_ID** - Get from Cloudflare dashboard

### Step 6: Restart Claude Code

```bash
# Exit and restart Claude Code for MCP servers to load
# Then verify:
claude doctor
claude mcp list
```

---

## 📋 What You Get

### Landing Page Project
- **Next.js 14** app with TypeScript
- **TailwindCSS** + shadcn/ui components
- **Market Research** - Complete competitor analysis
- **10-Step Playbook** - Launch strategy
- **UX Analysis** - DOGO, Pupford, Puppr, Woofz

### Claude Code Environment
- **18+ MCP Servers** ready to use
- **Auto-approval** configuration (maximum productivity)
- **Custom Tools** - OptionsFlow trading analysis
- **Complete Docs** - Setup, troubleshooting, restoration guides

---

## 🎯 For Your Next Claude Session

**Prompt to start your next session:**

```
Hi! I'm continuing work on the dog training tracker landing page.

Context:
- Repository: https://github.com/drewsen-toptal/dog-training-tracker-landing
- I've already cloned it to ~/dog-training-tracker-landing
- Landing page built with Next.js 14 + TailwindCSS + shadcn/ui
- Complete market research and 10-step launch playbook in root directory

Please:
1. Read the current state from CLAUDE_SESSION_PROMPT.md in the repo root
2. Review the 10_STEP_PLAYBOOK.md to understand our launch strategy
3. Check MARKET_RESEARCH_COMPLETE.md for competitive analysis
4. Let me know what step we should tackle next

The Claude Code environment backup is in .claude-backup/ if you need MCP server info.
```

**Alternative shorter prompt:**

```
Continue work on dog training tracker landing page at ~/dog-training-tracker-landing.
Read CLAUDE_SESSION_PROMPT.md and 10_STEP_PLAYBOOK.md, then suggest next steps.
```

---

## 📂 Repository Structure

```
dog-training-tracker-landing/
├── README.md                          # Project overview
├── NEW_MACHINE_SETUP.md              # This file
├── CLAUDE_SESSION_PROMPT.md          # Context for Claude sessions
├── 10_STEP_PLAYBOOK.md               # Launch strategy
├── MARKET_RESEARCH_COMPLETE.md       # Competitor analysis
├── app/                              # Next.js app directory
├── components/                       # React components
├── public/                           # Static assets
├── .claude-backup/                   # Claude Code environment
│   ├── README.md                     # Backup overview
│   ├── QUICK_START.md               # 5-min restoration
│   ├── SETUP_INSTRUCTIONS.md        # Detailed setup
│   ├── CURRENT_STATE.md             # Environment snapshot
│   ├── claude_desktop_config.json   # MCP configuration
│   ├── mcp-servers.json             # Server definitions
│   └── custom-mcp-servers/          # Custom tools
├── DOGO_UX_RESEARCH_ANALYSIS.md     # Competitor UX analysis
├── pupford-ux-analysis.md
├── puppr-ux-analysis.md
└── woofz-ux-analysis.md
```

---

## 🔧 Troubleshooting

### Landing Page Won't Start

```bash
cd ~/dog-training-tracker-landing
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### MCP Servers Not Working

```bash
# Check Claude Code status
claude doctor

# Restart Claude Code completely
# Then check MCP servers
claude mcp list

# Verify config location
ls -la ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Missing API Keys

```bash
cd ~/dog-training-tracker-landing/.claude-backup
cat credentials.env.example
# Copy and configure with your keys
```

---

## 📚 Important Files to Read First

1. **CLAUDE_SESSION_PROMPT.md** - Context for your session
2. **10_STEP_PLAYBOOK.md** - What we're building and why
3. **MARKET_RESEARCH_COMPLETE.md** - Competitive landscape
4. **.claude-backup/CURRENT_STATE.md** - Tech stack and environment
5. **.claude-backup/QUICK_START.md** - MCP server setup

---

## 🎓 Learning Resources

### Project Documentation
- Market Research: `MARKET_RESEARCH_COMPLETE.md`
- UX Analyses: `*-ux-analysis.md` files
- Launch Strategy: `10_STEP_PLAYBOOK.md`
- Accessibility: `WCAG-2.1-AA-ACCESSIBILITY-AUDIT.md`

### Claude Code Environment
- MCP Servers: `.claude-backup/mcp-servers.json`
- Setup Guide: `.claude-backup/SETUP_INSTRUCTIONS.md`
- Current State: `.claude-backup/CURRENT_STATE.md`

### Next.js + TailwindCSS
- Official Next.js docs: https://nextjs.org/docs
- shadcn/ui components: https://ui.shadcn.com
- TailwindCSS docs: https://tailwindcss.com/docs

---

## ✅ Verification Checklist

After setup, verify everything works:

### Landing Page
- [ ] `npm run dev` starts successfully
- [ ] Page loads at http://localhost:3000
- [ ] No console errors
- [ ] Screenshots display properly

### Claude Code Environment (Optional)
- [ ] `claude doctor` shows healthy
- [ ] `claude mcp list` shows 18+ connected servers
- [ ] Model is Claude Opus 4.5 (or Sonnet 4.5)
- [ ] Can run basic commands like `claude "list files"`

### Repository
- [ ] Git remote points to correct repo
- [ ] All documentation files present
- [ ] `.claude-backup/` directory exists

---

## 🚨 Common Issues

| Issue | Solution |
|-------|----------|
| Port 3000 already in use | `lsof -ti:3000 \| xargs kill -9` or use different port |
| npm install fails | Delete `node_modules/` and `package-lock.json`, retry |
| MCP servers won't connect | Restart Claude Code completely |
| Missing dependencies | Run `npm install` in project root |
| Python venv errors | Reinstall: `cd ~/mcp-optionsflow && rm -rf .venv && python3 -m venv .venv` |

---

## 💡 Pro Tips

1. **Always start Claude sessions by reading `CLAUDE_SESSION_PROMPT.md`** - it has the full context

2. **Use the 10-step playbook** - don't reinvent the wheel, follow the strategy

3. **Check market research** before making design decisions - we've analyzed competitors

4. **MCP servers are optional** - the landing page works without them (they're for enhanced Claude Code capabilities)

5. **Incremental progress** - focus on one step of the playbook at a time

6. **Test frequently** - run `npm run dev` after changes

---

## 🎯 Next Steps After Setup

Once setup is complete:

1. **Read the context**: `CLAUDE_SESSION_PROMPT.md`
2. **Review the strategy**: `10_STEP_PLAYBOOK.md`
3. **Start development**: Pick the next step from the playbook
4. **Iterate**: Make changes, test, commit, repeat

---

## 📞 Need Help?

- **Project issues**: Check GitHub issues at https://github.com/drewsen-toptal/dog-training-tracker-landing/issues
- **Claude Code issues**: Run `claude doctor` and check `.claude-backup/SETUP_INSTRUCTIONS.md`
- **Next.js issues**: Check Next.js docs or run `npm run build` for detailed errors

---

**Last Updated**: 2025-12-28
**Repository**: https://github.com/drewsen-toptal/dog-training-tracker-landing
**Claude Code Version**: 3.0.1
**Next.js Version**: 14.x
**Node Version**: 23.5.0

---

## 🎉 You're Ready!

Everything is set up for continuation. Start your Claude session with the prompt above and keep building! 🚀

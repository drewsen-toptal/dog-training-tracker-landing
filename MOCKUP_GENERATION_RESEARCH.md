# Mobile App Screenshot & Mockup Generation Research
## Research conducted: 2025-12-27

This comprehensive research document outlines available tools, MCPs, and approaches for generating realistic iOS app screenshots for a dog training app landing page featuring:
1. Progress tracking dashboard
2. Built-in clicker interface
3. Command library

---

## CATEGORY 1: AI Image Generation MCPs

### 1.1 Stability AI MCP Server
**Repository:** https://github.com/tadasant/mcp-server-stability-ai

**How to Use:**
```bash
# Quick install via Smithery
npx @smithery/cli install mcp-server-stability-ai --client claude

# Manual setup in claude_desktop_config.json
{
  "mcpServers": {
    "stability-ai": {
      "command": "npx",
      "args": ["-y", "mcp-server-stability-ai"],
      "env": {
        "STABILITY_AI_API_KEY": "sk-your-key"
      }
    }
  }
}
```

**Features:**
- 12 image manipulation tools (generation, editing, upscaling, etc.)
- Standard image generation and SD3.5 model variants
- Search-and-replace, recoloring, background replacement
- Upscaling (fast and creative modes)
- Sketch-to-image, style transfer, structure matching

**Requirements:**
- API Key from platform.stability.ai
- Local storage directory for generated images
- Node.js for running npx commands

**Pricing:** $0.01-$0.25 per credit depending on operation

**Pros:**
- Integrated directly into Claude Desktop
- Multiple image manipulation capabilities
- High-quality AI-generated images

**Cons:**
- NOT ideal for UI mockups - designed for general image generation
- Requires API costs per image
- Won't generate realistic app UI screenshots (would create artistic interpretations)
- No built-in device frame/mockup capabilities

**Recommendation for Dog Training App:** ❌ NOT RECOMMENDED
- While powerful for general AI art, this won't create realistic iOS app screenshots
- Better suited for marketing imagery, not interface mockups

---

### 1.2 Multi-Provider Image Gen MCP Server
**Repository:** https://github.com/merlinrabens/image-gen-mcp-server

**Supported Providers:**
| Provider | Specialty | Best For |
|----------|-----------|----------|
| OpenAI (DALL-E) | General purpose, text rendering | Marketing images |
| BFL (FLUX.2) | Photorealism, product shots | Hero images |
| Stability AI | Controlled generation | Artistic content |
| Ideogram | Typography, logos | Branding |
| Gemini (Imagen) | Multi-image composition | Collages |
| FAL | Fast iterations | Quick concepts |
| Replicate | Open models | Experimentation |

**Installation for Claude Code:**
```bash
/plugin marketplace add shipdeckai/claude-skills
/plugin install image-gen@shipdeckai/claude-skills
```

**Configuration:** Requires API keys in shell profile for each provider

**Pros:**
- Access to multiple AI providers in one MCP
- Flexible provider selection
- Good for generating marketing/hero images

**Cons:**
- Same fundamental issue - generates AI art, not realistic UI mockups
- Expensive for multiple variations
- No iOS device frame integration
- Results would be artistic interpretations, not pixel-perfect UI designs

**Recommendation for Dog Training App:** ❌ NOT RECOMMENDED
- These are for creative imagery, not functional UI screenshots

---

## CATEGORY 2: App Store Screenshot Generators (Specialized Tools)

### 2.1 Orshot - App Store Screenshot API ⭐ RECOMMENDED
**Website:** https://orshot.com/templates/app-store-screenshot-simple
**Type:** REST API with templates

**How to Use:**
```javascript
await fetch("https://api.orshot.com/v1/generate/images", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: "Bearer <ORSHOT_API_KEY>",
  },
  body: JSON.stringify({
    "templateId": "app-store-screenshot-simple",
    "response": {
      "format": "png",
      "type": "base64",
      "scale": 1
    },
    "modifications": {
      "size": "6.5",  // iPhone size
      "title": "Track Your Dog's Training Progress",
      "screenshotImage": "https://your-app/screenshot.png",
      "textColor": "#111",
      "backgroundColor": "#fff"
    }
  }),
});
```

**Customization Parameters:**
- `size`: iOS device size (6.9", 6.5", 6.3", 5.8" options)
- `title`: Caption text (clips after 2nd line)
- `screenshotImage`: URL or base64-encoded iOS screenshot
- `textColor`: CSS color for title
- `backgroundColor`: CSS color for background

**SDK Support:**
- Node.js
- Python
- Ruby
- PHP

**Integration:** Works with n8n, Make, Airtable, Zapier, Pipedream

**Pros:**
- REST API - fully programmatic
- Specifically designed for App Store screenshots
- Multiple device sizes supported
- Can automate bulk generation
- Clean, professional output
- Supports latest iOS devices

**Cons:**
- Requires pre-existing app screenshots (doesn't generate the UI itself)
- Pricing not publicly listed on main page
- Limited template customization

**Recommendation for Dog Training App:** ✅ EXCELLENT CHOICE
- Perfect for adding device frames and captions to your screenshots
- You'd need to create the actual UI screens first (see Category 4)

---

### 2.2 AppScreens
**Website:** https://appscreens.com/
**Type:** Web-based generator with Figma integration

**Features:**
- Responsive design - create once, export for all devices
- Supports all iOS & Android device sizes
- Bulk import from Fastlane format
- Rich text and overlay support
- Multi-language export

**How to Use:**
1. Import raw screenshots (from simulator or Fastlane)
2. Choose device templates
3. Add text overlays, backgrounds
4. Export for all required sizes

**Pros:**
- Integrates with existing Fastlane workflows
- Great ASO (App Store Optimization) features
- More design flexibility than templates
- Over 70k users, 5M+ screenshots exported

**Cons:**
- Primarily UI-based (less programmatic)
- Requires manual design work
- Not a pure API solution

**Recommendation for Dog Training App:** ✅ GOOD OPTION
- Best if you want more design control
- Great for final polish after generating base screenshots

---

### 2.3 Screenshots Pro
**Website:** https://screenshots.pro/
**Type:** Online generator with REST API

**Features:**
- Auto-generate App Store screenshots using REST API
- iOS & Android support
- Free online generator
- API available for automation

**Pros:**
- Has both UI and API options
- Specifically built for app store submissions

**Cons:**
- Less documentation available
- Unclear pricing structure

**Recommendation for Dog Training App:** ⚠️ WORTH INVESTIGATING
- Could be good alternative to Orshot if pricing is better

---

### 2.4 LaunchMatic
**Website:** https://www.launchmatic.app/
**Type:** Template-based generator

**Features:**
- Tons of customizable templates by UIX designers
- Google Translate API integration for multi-language
- Supports all iOS & Android devices

**Pros:**
- Pre-designed professional templates
- Good for quick, polished results
- Multi-language support built-in

**Cons:**
- Template-based (less custom)
- Primarily UI-driven workflow
- No clear API access

**Recommendation for Dog Training App:** ⚠️ MODERATE
- Good for speed, but limited customization

---

## CATEGORY 3: 3D Mockup & Animation Tools

### 3.1 Rotato (Mac App) ⭐ HIGHLY RECOMMENDED
**Website:** https://rotato.app/
**Platform:** macOS only

**Features:**
- Cinematic 3D animations
- 30+ battle-tested 3D devices
- 100% customizable (reflections, DSLR controls, backgrounds, colors)
- 9x faster than Adobe Premiere/After Effects
- Still mockups and interactive 3D models

**Pricing:** Unlimited trial, Pro version $69 one-time fee

**How to Use:**
1. Import your app screenshots
2. Choose device model (iPhone, iPad, etc.)
3. Customize angle, lighting, background
4. Export as image or animation

**Pros:**
- Professional, cinematic quality
- Perfect for hero images on landing page
- One-time payment (not subscription)
- Extremely fast rendering
- Great for app promo videos too

**Cons:**
- Mac only (no Windows/Linux)
- Not programmatic (desktop app)
- Requires manual work per screenshot

**Recommendation for Dog Training App:** ✅ EXCELLENT FOR HERO IMAGES
- Use this for your main landing page hero mockups
- Creates stunning 3D device presentations
- Worth the $69 investment for professional results

---

### 3.2 MockRocket
**Website:** https://mockrocket.io/
**Type:** Web-based 3D mockup generator

**Features:**
- Browser-based (Chrome/Edge)
- 3D device mockups and animations
- Figma plugin available
- Free plan with watermarked images

**Pros:**
- No software installation needed
- Works on any platform
- Free tier available
- Figma integration

**Cons:**
- Watermarked on free plan
- Less polished than Rotato
- Browser performance limitations

**Recommendation for Dog Training App:** ⚠️ GOOD FREE ALTERNATIVE
- Try this if you're on Windows/Linux
- Free tier for testing before investing

---

### 3.3 Previewed
**Website:** https://previewed.app/
**Type:** Web-based mockup generator

**Features:**
- 3D device animations and still mockups
- 100+ ready-made templates
- Custom camera & environment controls
- Free tier available

**Pricing:**
- Lite: Free (single app/project)
- Plus: $9.99 one-time (commercial use)
- Pro: $19/month (advanced features)

**How to Use:**
1. Choose from 100+ templates
2. Upload your screenshots
3. Customize colors, angles, position
4. Create animations or still images
5. Export for web or App Store

**Pros:**
- Very affordable ($9.99 one-time for commercial)
- Template library speeds up workflow
- Animation support included
- Works in browser (cross-platform)

**Cons:**
- Not as polished as Rotato
- Free tier very limited
- Monthly fee for Pro features

**Recommendation for Dog Training App:** ✅ EXCELLENT VALUE
- Best bang-for-buck at $9.99 one-time
- Perfect for landing page mockups

---

## CATEGORY 4: AI UI Design Generators (Create the UI First)

### 4.1 Uizard ⭐ RECOMMENDED FOR UI CREATION
**Website:** https://uizard.io/
**Type:** AI-powered UI design tool

**Features:**
- **Autodesigner:** Text prompts → full UI designs
- **Screenshot Scanner:** Convert screenshots → editable mockups
- **Sketch to Wireframe:** Hand-drawn sketches → digital wireframes
- **Focus Predictor:** AI heatmap showing user attention areas

**Pricing:**
- Free tier with Autodesigner 1.5
- Pro plan for Autodesigner 2.0 (smarter suggestions, component editing)

**How to Use for Dog Training App:**
1. Prompt: "Create an iOS dog training progress dashboard showing completed sessions, success rate chart, and upcoming goals"
2. Prompt: "Design an iOS clicker training interface with large tap button, click counter, and sound settings"
3. Prompt: "Design a command library list view showing dog commands with icons, difficulty levels, and progress indicators"
4. Export designs as PNG
5. Use with Orshot or Rotato to add device frames

**Pros:**
- Generates actual UI designs (not just artistic images)
- Fast prototyping from text descriptions
- Editable components
- Export-ready designs

**Cons:**
- Designs may need refinement
- Not pixel-perfect iOS components
- Learning curve for customization

**Recommendation for Dog Training App:** ✅ BEST FOR QUICK UI GENERATION
- Start here to create your base screenshots
- Then enhance with Orshot/Rotato

---

### 4.2 Galileo AI (Stitch)
**Website:** https://www.usegalileo.ai/
**Type:** AI UI generation platform

**Features:**
- Text prompt → high-fidelity wireframes
- Editable designs with customizable fonts, colors, border-radius
- Direct Figma file export
- HTML + Tailwind code export
- Replit integration for immediate code testing

**Pricing:** Very restricted free plan, paid plans for teams

**How to Use:**
1. Enter text prompt describing screen
2. Customize visual style (fonts, colors, etc.)
3. Export to Figma or code
4. Render in browser/simulator
5. Take screenshots for mockup tools

**Pros:**
- Production-friendly output
- Direct Figma integration
- Code export (HTML/Tailwind)
- Great for developer handoff

**Cons:**
- Restricted free plan
- More complex than Uizard
- May require design knowledge

**Recommendation for Dog Training App:** ✅ GOOD FOR PRODUCTION-READY DESIGNS
- Use if you want code output
- Better for real app development, not just mockups

---

### 4.3 Figma with AI Plugins
**Website:** https://www.figma.com/
**Relevant Plugins:**
- Figma Make (AI mockup generator)
- Mockey AI (realistic mockup generator)
- Mockup Plugin (4800+ mockups)

**How to Use:**
1. Design UI screens in Figma (or use AI plugin to generate)
2. Install mockup plugin
3. Apply device frames
4. Export as PNG

**Pros:**
- Industry-standard design tool
- Huge plugin ecosystem
- Precise control over design
- Free tier available

**Cons:**
- Requires design skills
- Time-intensive for mockups
- Not automated

**Recommendation for Dog Training App:** ⚠️ BEST FOR CUSTOM DESIGNS
- Use if you have design skills
- Time investment pays off in quality

---

## CATEGORY 5: Programmatic/Automation Approaches

### 5.1 Playwright + HTML/CSS Templates ⭐ RECOMMENDED FOR AUTOMATION
**Approach:** Build HTML mockups, screenshot with Playwright

**How to Use:**
```javascript
const { chromium, devices } = require('playwright');

(async () => {
  const browser = await chromium.launch();

  // Emulate iPhone 12
  const iPhone12 = devices['iPhone 12'];
  const context = await browser.newContext({
    ...iPhone12,
    deviceScaleFactor: 2  // Retina quality
  });

  const page = await context.newPage();

  // Load your HTML mockup
  await page.goto('file:///path/to/mockup.html');

  // Take screenshot
  await page.screenshot({
    path: 'dog-training-dashboard.png',
    fullPage: true
  });

  await browser.close();
})();
```

**Flowbite Tailwind CSS Device Frames:**
```html
<!-- iPhone 12 Frame -->
<div class="relative mx-auto border-gray-800 bg-gray-800 border-[14px] rounded-[2.5rem] h-[600px] w-[300px]">
  <!-- Top notch -->
  <div class="w-[148px] h-[18px] bg-gray-800 top-0 rounded-b-[1rem] left-1/2 -translate-x-1/2 absolute"></div>

  <!-- Side buttons -->
  <div class="h-[32px] w-[3px] bg-gray-800 absolute -start-[17px] top-[72px] rounded-s-lg"></div>
  <div class="h-[46px] w-[3px] bg-gray-800 absolute -start-[17px] top-[124px] rounded-s-lg"></div>

  <!-- Screen content -->
  <div class="rounded-[2rem] overflow-hidden w-[272px] h-[572px] bg-white">
    <!-- Your app UI goes here -->
    <div class="p-4">
      <h1 class="text-2xl font-bold">Training Progress</h1>
      <!-- Dashboard content -->
    </div>
  </div>
</div>
```

**Full Workflow:**
1. Create HTML mockups using Tailwind CSS (Flowbite device frames)
2. Build actual UI screens inside the frames
3. Use Playwright to render and screenshot at 2x scale
4. Automated pipeline for all 3 screens

**Pros:**
- Fully programmatic and repeatable
- Version-controlled HTML templates
- Free (no API costs)
- Pixel-perfect control
- Easy to update and regenerate
- Can use real CSS/HTML for UI

**Cons:**
- Requires web development skills
- Initial setup time
- Need to design UI in HTML/CSS
- No 3D effects (flat mockups only)

**Recommendation for Dog Training App:** ✅ BEST FOR AUTOMATION & ITERATION
- Perfect if you'll be updating screenshots frequently
- Complete control over design
- Can integrate into CI/CD pipeline
- Use Flowbite components for device frames

**Sample Project Structure:**
```
/mockups
  /templates
    - iphone-frame.html
    - styles.css
  /screens
    - dashboard.html
    - clicker.html
    - commands.html
  /scripts
    - generate-screenshots.js (Playwright script)
  /output
    - dashboard-iphone12.png
    - clicker-iphone12.png
    - commands-iphone12.png
```

---

### 5.2 Screenshot.rocks (Self-Hosted)
**Repository:** https://github.com/daveearley/screenshot.rocks
**Type:** Open-source web app

**Tech Stack:**
- TypeScript (62.9%)
- CSS (30.2%)
- Vercel deployment
- `/api` directory (potential API access)
- `/screenshot-lambda` (AWS Lambda screenshot processing)

**How to Use:**
```bash
# Clone and setup
git clone https://github.com/daveearley/screenshot.rocks.git
cd screenshot.rocks
yarn install
yarn start
```

**Features:**
- Create mobile & browser mockups from screenshots
- Browser extensions (Firefox, Chrome, Edge)
- MIT license (fully open-source)
- Customizable device frames

**Pros:**
- Free and open-source
- Self-hostable
- Can potentially add API endpoints
- Active development (791 stars)

**Cons:**
- No official API documented
- Requires hosting/maintenance
- Would need customization for automation

**Recommendation for Dog Training App:** ⚠️ ADVANCED OPTION
- Only if you want to self-host
- Could modify for API access
- Requires development effort

---

### 5.3 Puppeteer + HTML Canvas
**Similar to Playwright but with Canvas API support**

**Use Case:** If you need canvas-based rendering (charts, graphs)

**Library:** puppet-canvas
```javascript
const { CanvasRenderingContext2D } = require('puppet-canvas');

// Use Puppeteer with canvas rendering
// Then screenshot the result
```

**Pros:**
- Canvas support for charts (perfect for progress tracking dashboard!)
- Node.js backend rendering
- Programmatic control

**Cons:**
- More complex setup
- Canvas learning curve
- Similar to Playwright but more specialized

**Recommendation for Dog Training App:** ⚠️ CONSIDER IF USING CHARTS
- Your progress dashboard might have charts
- Could use Chart.js + puppet-canvas
- Then screenshot with Puppeteer

---

## CATEGORY 6: Template-Based Services (Quick & Easy)

### 6.1 Hotpot.ai
**Website:** https://hotpot.ai/app-store-screenshot-generator
**Type:** Online generator, free for indies

**Features:**
- All latest iOS and Android devices
- iPhone 12 Pro Max, iPad Pro, Samsung Galaxy S21
- Multiple export formats
- Brand customization

**Pros:**
- Free for indie developers
- Easy to use
- Good device selection

**Cons:**
- Manual process
- Not programmatic
- Limited customization

**Recommendation:** ⚠️ QUICK START OPTION
- Try first to see output quality
- Not for automation

---

### 6.2 Device Frames
**Website:** https://deviceframes.com/
**Type:** 3D device mockup generator

**Features:**
- Beautiful 3D device scenes
- Perfect for landing pages, social media, ads, pitch decks
- App promo videos

**Pros:**
- Specifically designed for marketing materials
- Professional 3D output

**Cons:**
- Pricing unclear
- Not API-based

**Recommendation:** ⚠️ ALTERNATIVE TO ROTATO
- If you want 3D but don't have Mac

---

## RECOMMENDED WORKFLOW FOR DOG TRAINING APP

### Option A: Fast & Professional (Recommended for MVP)
**Total Cost: ~$78.99 one-time**

1. **Create UI Designs** ($0)
   - Use Uizard (free tier) to generate 3 screens from text prompts
   - Export as PNG files

2. **Add Device Frames** ($9.99)
   - Use Previewed Plus ($9.99 one-time)
   - Upload Uizard PNGs
   - Choose iPhone mockup templates
   - Export App Store-ready screenshots

3. **Create Hero Image** ($69)
   - Use Rotato ($69 one-time) on Mac
   - Create stunning 3D mockup for landing page hero
   - Add animation for video demo

**Pros:**
- Professional results fast
- One-time costs
- No coding required
- High quality output

**Cons:**
- Manual process
- Hard to update/iterate
- Requires Mac for Rotato

---

### Option B: Fully Automated (Best for Long-term)
**Total Cost: $0 (time investment)**

1. **Build HTML Mockups**
   - Use Flowbite Tailwind CSS device frames
   - Create 3 HTML pages (dashboard, clicker, commands)
   - Style with Tailwind CSS
   - Add realistic UI components

2. **Screenshot Pipeline**
   - Create Playwright script
   - Configure iPhone 12 device emulation
   - Screenshot at 2x scale (retina)
   - Output PNG files

3. **Automation Script**
   ```bash
   npm run generate-mockups
   # Outputs: dashboard.png, clicker.png, commands.png
   ```

4. **Optional: Add to CI/CD**
   - Regenerate screenshots on every design change
   - Commit to version control
   - Deploy to landing page automatically

**Pros:**
- Free (no recurring costs)
- Fully automated
- Easy to update
- Version controlled
- Reproducible

**Cons:**
- Initial development time
- Requires HTML/CSS skills
- Flat mockups (no 3D)
- No fancy animations

---

### Option C: Hybrid Approach (Best of Both Worlds)
**Total Cost: ~$10-70 depending on choices**

1. **Generate Base UI** (Free)
   - Uizard or Galileo AI for quick designs
   - OR build custom HTML/CSS templates

2. **Automated Screenshots** (Free)
   - Playwright pipeline for consistent output
   - Can regenerate anytime

3. **Polish for Marketing** ($10-70)
   - Use Previewed ($9.99) for App Store screenshots
   - Use Rotato ($69) for hero image 3D mockup
   - Manual process only for final marketing materials

**Pros:**
- Automation for development
- Professional polish for marketing
- Flexible workflow
- Cost-effective

**Cons:**
- Two separate workflows
- Some manual steps

---

## SPECIFIC RECOMMENDATIONS FOR EACH SCREEN

### 1. Progress Tracking Dashboard
**Suggested Tools:**
- **UI Generation:** Uizard prompt: "iOS app dashboard showing dog training progress with weekly activity chart, success rate percentage, streak counter, and recent achievements list"
- **Or HTML:** Build with Chart.js for progress charts + Tailwind CSS
- **Mockup:** Playwright for automation, or Rotato for hero image

**Key Elements to Show:**
- Weekly progress chart
- Success rate metric (e.g., "78% success rate")
- Current streak (e.g., "7 day streak")
- Recent training sessions list
- Upcoming goals

---

### 2. Built-in Clicker Interface
**Suggested Tools:**
- **UI Generation:** Uizard prompt: "iOS clicker training screen with large circular tap button, click counter, sound wave animation, and settings gear icon"
- **Or HTML:** Simple centered layout with CSS animations
- **Mockup:** Any option works well (simple screen)

**Key Elements to Show:**
- Large, prominent click button (center)
- Click counter (e.g., "23 clicks")
- Visual feedback (animation or color change)
- Sound settings icon
- Simple, clean interface

---

### 3. Command Library
**Suggested Tools:**
- **UI Generation:** Uizard prompt: "iOS command library list showing dog training commands with icon, name, difficulty badge, progress bar, and arrow for details"
- **Or HTML:** Tailwind CSS list components with icons
- **Mockup:** Playwright automation or Previewed templates

**Key Elements to Show:**
- List of commands (Sit, Stay, Come, Down, Heel)
- Difficulty indicators (Beginner, Intermediate, Advanced)
- Progress bars for each command
- Icons for visual interest
- Search/filter option

---

## FINAL RECOMMENDATION

**For your dog training app landing page, I recommend:**

### Immediate Solution (This Week):
1. **Uizard** (free) - Generate 3 UI screens from prompts in 30 minutes
2. **Previewed** ($9.99 one-time) - Add device frames and export
3. **Total time:** 2-3 hours, **Total cost:** $9.99

### Professional Upgrade (Optional):
4. **Rotato** ($69) - Create one stunning 3D hero mockup for landing page
5. **Total cost:** $78.99 one-time

### Long-term Automation (Next Month):
5. Build Playwright + Flowbite Tailwind pipeline
6. Replace Uizard screens with custom HTML/CSS
7. Automate screenshot generation
8. **Total cost:** $0 (your time only)

---

## TOOLS TO AVOID

### ❌ General AI Image Generation (DALL-E, Midjourney, Stable Diffusion)
**Why:** These create artistic interpretations, not realistic UI screenshots. You'll get AI-generated "app-like" images that look fake and inconsistent. Not suitable for professional landing pages.

### ❌ Unofficial Midjourney APIs
**Why:** Risk of account bans, expensive, and still produces artistic images not realistic mockups.

### ❌ Complex 3D Design Tools (Blender, Cinema 4D)
**Why:** Massive overkill, steep learning curve, when simpler tools exist.

---

## NEXT STEPS

1. **Decide on workflow:** Fast ($9.99) vs Automated (free but time investment)
2. **Create UI designs:** Use Uizard prompts or build HTML templates
3. **Generate mockups:** Apply device frames with chosen tool
4. **Integrate into landing page:** Add screenshots to your Next.js site

Need help implementing any of these approaches? Let me know which workflow you prefer!

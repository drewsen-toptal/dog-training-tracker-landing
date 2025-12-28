# iOS App Screenshots - Dog Training Tracker

## Overview
Three realistic iOS app screenshots have been generated for the Dog Training Tracker landing page. These screenshots showcase the app's core features with a professional, modern design using the brand's teal and amber color scheme.

## Generated Screenshots

### 1. Progress Dashboard (`progress-dashboard.png`)
**Location:** `/Users/drew.sen/.playwright-mcp/progress-dashboard.png`

**Features Shown:**
- Dog profile header with avatar (Max - Golden Retriever, 8 months)
- **87% Success Rate** stat card with teal checkmark icon
- **12 Day Streak** stat card with amber flame icon
- Weekly Activity bar chart showing daily training sessions
- Recent Achievements section with 3 achievements:
  - Week Warrior (trained 7 days straight)
  - Command Master (mastered "Sit" command)
  - Perfect Session (100% success rate today)

**Design Elements:**
- iOS status bar with notch
- Warm cream background (oklch 0.985 0.008 85)
- White cards with subtle shadows
- Teal primary color for success indicators
- Amber secondary color for streak/achievement highlights
- iOS home indicator at bottom

---

### 2. Built-in Clicker (`clicker.png`)
**Location:** `/Users/drew.sen/.playwright-mcp/clicker.png`

**Features Shown:**
- Large circular tap button (280px diameter)
- Teal gradient with glow effect
- Concentric ring indicators around button
- **Total Clicks Counter:** 247 (large display)
- **Session Timer:** 05:43 with clock icon
- **Sound Toggle:** ON indicator with speaker icon
- Action buttons:
  - Reset button (white/outline style)
  - Save Session button (teal primary)

**Design Elements:**
- Clean, minimal interface focused on the clicker
- Large touch-friendly button with visual feedback
- White cards for session info
- Responsive layout optimized for one-handed use

---

### 3. Command Library (`command-library.png`)
**Location:** `/Users/drew.sen/.playwright-mcp/command-library.png`

**Features Shown:**
- Search bar at top ("Search commands...")
- **6 Commands Listed:**
  1. **Sit** - 100% mastery, 48 sessions (Mastered badge - teal, Easy difficulty - amber)
  2. **Stay** - 68% mastery, 24 sessions (Medium difficulty)
  3. **Come** - 45% mastery, 15 sessions (Medium difficulty)
  4. **Down** - 32% mastery, 8 sessions (Easy difficulty)
  5. **Heel** - 18% mastery, 5 sessions (Hard difficulty - red)
  6. **Leave It** - Not started (Medium difficulty)

**Design Elements:**
- Each command card shows:
  - Icon in colored background circle
  - Command name
  - Difficulty badge
  - Progress bar (teal fill)
  - Percentage and session count
- Visual hierarchy with border accent on mastered command
- Scrollable list layout
- Distinct icons for each command type

---

## Color Scheme (Brand Colors)

### Primary (Teal)
- Color: `oklch(0.62 0.14 185)`
- Usage: Success indicators, primary buttons, progress bars, mastered badges

### Secondary (Amber)
- Color: `oklch(0.78 0.16 65)`
- Usage: Streak indicators, achievements, difficulty badges (Easy)

### Background
- Color: `oklch(0.985 0.008 85)` (warm cream)
- Creates welcoming, friendly atmosphere

### Typography
- San Francisco (iOS system font)
- Font weights: 400 (regular), 600 (semibold), 700 (bold)

---

## Technical Specifications

### Device
- **Model:** iPhone 14 Pro
- **Resolution:** 390x844 pixels
- **Aspect Ratio:** 19.5:9
- **Display Features:**
  - iOS notch
  - Status bar (time, signal, battery)
  - Home indicator

### iOS Elements
- Status bar with realistic iOS UI
- Home indicator (rounded pill at bottom)
- System fonts and spacing
- Native iOS blur effects and shadows

---

## File Locations

### HTML Mockups (Source)
1. `/Users/drew.sen/dog-training-tracker/landing-page/mockups/progress-dashboard.html`
2. `/Users/drew.sen/dog-training-tracker/landing-page/mockups/clicker.html`
3. `/Users/drew.sen/dog-training-tracker/landing-page/mockups/command-library.html`

### Screenshots (Generated)
1. `/Users/drew.sen/.playwright-mcp/progress-dashboard.png`
2. `/Users/drew.sen/.playwright-mcp/clicker.png`
3. `/Users/drew.sen/.playwright-mcp/command-library.png`

### To Copy to Public Folder
Run the copy script:
```bash
cd /Users/drew.sen/dog-training-tracker/landing-page
node copy-screenshots.js
```

This will copy all three screenshots to:
- `public/screenshots/progress-dashboard.png`
- `public/screenshots/clicker.png`
- `public/screenshots/command-library.png`

---

## Usage in Landing Page

These screenshots can be used in:
1. **Hero section** - Show the progress dashboard to highlight tracking features
2. **Features section** - Display all three to showcase different app capabilities
3. **App Screenshots carousel** - Create an interactive slider with all screens
4. **Social proof** - Use in testimonials or case study sections

### Example Code

```tsx
import Image from 'next/image';

// Single screenshot
<Image
  src="/screenshots/progress-dashboard.png"
  alt="Dog Training Progress Dashboard showing 87% success rate and 12-day streak"
  width={390}
  height={844}
  className="rounded-[2rem] shadow-2xl"
/>

// All three in a grid
<div className="grid md:grid-cols-3 gap-8">
  <Image src="/screenshots/progress-dashboard.png" alt="Progress Dashboard" width={390} height={844} />
  <Image src="/screenshots/clicker.png" alt="Built-in Clicker" width={390} height={844} />
  <Image src="/screenshots/command-library.png" alt="Command Library" width={390} height={844} />
</div>
```

---

## Design Notes

### Why These Screens?
1. **Progress Dashboard** - Shows value proposition (tracking, achievements, motivation)
2. **Clicker** - Highlights unique feature (built-in clicker eliminates need for separate device)
3. **Command Library** - Demonstrates depth (structured training, progress tracking per command)

### Brand Alignment
- Warm, approachable color scheme (teal + amber)
- Clean, uncluttered interface
- Focus on dog owner's success
- Professional but friendly tone

### Accessibility
- High contrast ratios (WCAG AA compliant)
- Large touch targets (44x44px minimum)
- Clear visual hierarchy
- Readable font sizes (minimum 13px)

---

## Next Steps

1. **Copy screenshots to public folder:**
   ```bash
   node copy-screenshots.js
   ```

2. **Optimize images** (optional):
   ```bash
   npx sharp-cli -i "public/screenshots/*.png" -o "public/screenshots/" -f webp
   ```

3. **Update AppScreenshots component** to use these images

4. **Add to landing page sections** where appropriate

5. **Consider A/B testing** different screenshot orders in carousel

---

## Credits

- **Design System:** Based on Apple Human Interface Guidelines
- **Color Scheme:** Dog Training Tracker brand colors (teal + amber)
- **Typography:** SF Pro Display (iOS system font)
- **Icons:** Lucide React (consistent with landing page)

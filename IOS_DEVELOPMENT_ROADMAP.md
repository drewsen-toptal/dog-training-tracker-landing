# Dog Training Tracker - iOS Development Roadmap

## Technical Stack

### Target
- **iOS 18.0+** (or iOS 26+ for Liquid Glass)
- **Swift 6.2+**
- **SwiftUI** (100% - no UIKit)
- **SwiftData** for persistence
- **CloudKit** for sync (optional)

### Available MCPs & Tools
| Tool | Purpose |
|------|---------|
| **xcodebuildmcp** | Build, run, test, scaffold projects |
| **ios-simulator-mcp** | Screenshot, tap, swipe, type, navigate |
| **cupertino** | Apple documentation (302K+ pages offline) |
| **apple-docs** | WWDC videos, code examples, API docs |
| **mobile-mcp** | Device control, app lifecycle |

### Available Skills
| Skill | Purpose |
|-------|---------|
| **swift-agents-guidelines** | Modern Swift/SwiftUI patterns |
| **swift-ai-code-quality** | Fix common AI code issues |
| **ios-simulator-skill** | 21 automation scripts |
| **axiom** | Liquid Glass, SwiftData, debugging |
| **apple-hig** | Human Interface Guidelines |

---

## Phase 1: Project Setup & Architecture

### 1.1 Scaffold iOS Project
```bash
# Using xcodebuildmcp
mcp__xcodebuildmcp__scaffold_ios_project({
  projectName: "DogTrainingTracker",
  outputPath: "/Users/drew.sen/dog-training-tracker/ios-app",
  bundleIdentifier: "com.drewsen.dogtrainingtracker",
  deploymentTarget: "18.0"
})
```

### 1.2 Define Data Models (SwiftData)
```
Models/
├── Dog.swift              # Dog profile (name, breed, photo)
├── Command.swift          # Training commands (sit, stay, come)
├── TrainingSession.swift  # Session records with timestamps
├── SessionResult.swift    # Individual command results
└── UserGoal.swift         # Daily/weekly goals
```

**CloudKit Compatibility Rules:**
- No `@Attribute(.unique)`
- All relationships optional
- Default values for all properties

### 1.3 Architecture Pattern
Using **Axiom** patterns:
```
Features/
├── Home/
│   ├── HomeView.swift
│   └── HomeViewModel.swift (@Observable)
├── Training/
│   ├── SessionView.swift
│   ├── SessionViewModel.swift
│   └── ClickerView.swift
├── Commands/
│   ├── CommandListView.swift
│   └── CommandDetailView.swift
├── Progress/
│   ├── ProgressDashboardView.swift
│   └── StatsViewModel.swift
└── Settings/
    ├── SettingsView.swift
    └── ProfileView.swift
```

---

## Phase 2: Wireframe-to-SwiftUI Conversion

### 2.1 Convert Each Mockup

| Mockup | SwiftUI View | Priority |
|--------|--------------|----------|
| `home-dashboard.html` | `HomeView.swift` | P0 |
| `training-session.html` | `TrainingSessionView.swift` | P0 |
| `clicker-v2.html` | `ClickerView.swift` | P0 |
| `command-detail.html` | `CommandDetailView.swift` | P1 |
| `progress-dashboard.html` | `ProgressDashboardView.swift` | P1 |
| `session-complete.html` | `SessionCompleteView.swift` | P1 |
| `settings-profile.html` | `SettingsView.swift` | P2 |
| `onboarding-*.html` | `OnboardingFlow.swift` | P2 |

### 2.2 Component Library
Extract reusable components:
```
Components/
├── DogAvatarView.swift        # Circular avatar with 3D images
├── StreakBadgeView.swift      # Fire streak indicator
├── ProgressRingView.swift     # Circular progress
├── CommandCardView.swift      # Command with progress
├── GoalCardView.swift         # Daily goal gradient card
├── WeeklyCalendarView.swift   # 7-day progress tracker
└── TabBarView.swift           # Custom bottom navigation
```

### 2.3 Asset Migration
```
Assets.xcassets/
├── AppIcon.appiconset/
├── Colors/
│   ├── TealPrimary.colorset   # oklch(0.55 0.15 165)
│   ├── AmberAccent.colorset   # oklch(0.75 0.14 55)
│   └── GreenSuccess.colorset  # oklch(0.65 0.18 145)
└── Images/
    ├── DogAvatars/            # 4 rotating 3D dogs
    ├── CommandIcons/          # Stay, Come, Down, etc.
    └── Illustrations/         # Onboarding graphics
```

---

## Phase 3: Build & Test Loop

### 3.1 Iterative Development Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVELOPMENT LOOP                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. WRITE CODE                                               │
│     └── Use swift-agents-guidelines skill                    │
│     └── Apply swift-ai-code-quality checks                   │
│                                                              │
│  2. BUILD                                                    │
│     └── mcp__xcodebuildmcp__build_sim()                     │
│     └── Fix any compiler errors                              │
│                                                              │
│  3. RUN IN SIMULATOR                                         │
│     └── mcp__xcodebuildmcp__build_run_sim()                 │
│                                                              │
│  4. VISUAL VERIFICATION                                      │
│     └── mcp__xcodebuildmcp__screenshot()                    │
│     └── Compare to HTML mockup                               │
│                                                              │
│  5. UI TESTING                                               │
│     └── mcp__xcodebuildmcp__describe_ui()                   │
│     └── mcp__xcodebuildmcp__tap({id: "button"})             │
│     └── mcp__ios-simulator-mcp__ui_type({text: "Max"})      │
│                                                              │
│  6. ITERATE                                                  │
│     └── Fix visual discrepancies                             │
│     └── Handle edge cases                                    │
│     └── Repeat until pixel-perfect                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Testing Commands

```swift
// Build for simulator
mcp__xcodebuildmcp__build_sim()

// Run with logs
mcp__xcodebuildmcp__build_run_sim()

// Take screenshot for comparison
mcp__xcodebuildmcp__screenshot()

// Get UI hierarchy for interaction
mcp__xcodebuildmcp__describe_ui()

// Tap element by accessibility ID
mcp__xcodebuildmcp__tap({id: "startTrainingButton"})

// Type text
mcp__xcodebuildmcp__type_text({text: "Max"})

// Swipe/scroll
mcp__xcodebuildmcp__gesture({preset: "scroll-down"})

// Run unit tests
mcp__xcodebuildmcp__test_sim()
```

---

## Phase 4: Feature Implementation Order

### Sprint 1: Core Training Flow (Week 1-2)
- [ ] Project scaffold with SwiftData models
- [ ] HomeView with dog avatar and daily goal
- [ ] TrainingSessionView with command display
- [ ] ClickerView with haptic feedback
- [ ] Basic navigation (TabView)

### Sprint 2: Progress & History (Week 3-4)
- [ ] SessionCompleteView with results
- [ ] ProgressDashboardView with charts
- [ ] Command mastery tracking
- [ ] Weekly calendar visualization
- [ ] Streak calculation logic

### Sprint 3: Commands & Customization (Week 5-6)
- [ ] CommandListView with all commands
- [ ] CommandDetailView with tips
- [ ] Custom command creation
- [ ] Spaced repetition algorithm
- [ ] Due for review logic

### Sprint 4: Polish & Settings (Week 7-8)
- [ ] OnboardingFlow (4 screens)
- [ ] SettingsView with profile
- [ ] Notification scheduling
- [ ] Data export/import
- [ ] App Store assets

---

## Phase 5: Quality Assurance

### 5.1 Automated Testing Strategy
```
Tests/
├── UnitTests/
│   ├── SpacedRepetitionTests.swift
│   ├── StreakCalculatorTests.swift
│   └── SessionScoringTests.swift
├── IntegrationTests/
│   └── SwiftDataPersistenceTests.swift
└── UITests/
    ├── OnboardingFlowTests.swift
    ├── TrainingSessionTests.swift
    └── NavigationTests.swift
```

### 5.2 Using ios-simulator-skill for UI Testing
```bash
# Health check
sim_health_check.sh

# Screen analysis
screen_mapper.py

# Semantic navigation (resilient to UI changes)
navigator.py --find-text "Start Training" --tap
navigator.py --find-type TextField --enter-text "Max"

# Accessibility audit
accessibility_audit.py

# Visual regression
visual_diff.py --baseline baseline.png --current current.png
```

### 5.3 Accessibility Checklist
- [ ] All interactive elements have accessibility labels
- [ ] Dynamic Type support (no hardcoded font sizes)
- [ ] VoiceOver navigation works
- [ ] Sufficient color contrast
- [ ] Reduce Motion support

---

## Phase 6: Final Polish

### 6.1 Performance Optimization
Using Axiom's SwiftUI Performance skill:
- Profile with Instruments
- Minimize view body recalculations
- Lazy loading for lists
- Image caching strategy

### 6.2 App Store Preparation
- [ ] App icons (all sizes)
- [ ] Screenshots (6.7", 6.1", 5.5")
- [ ] App Preview video
- [ ] Privacy policy
- [ ] App Store description
- [ ] Keywords optimization

### 6.3 Launch Checklist
- [ ] TestFlight beta testing
- [ ] Crash-free rate > 99.5%
- [ ] All flows tested on real devices
- [ ] CloudKit sync verified
- [ ] Localization (if applicable)

---

## Quick Reference: MCP Commands

### Build & Run
```
mcp__xcodebuildmcp__build_sim()           # Build
mcp__xcodebuildmcp__build_run_sim()       # Build + Run
mcp__xcodebuildmcp__test_sim()            # Run tests
mcp__xcodebuildmcp__clean()               # Clean build
```

### UI Interaction
```
mcp__xcodebuildmcp__screenshot()          # Capture screen
mcp__xcodebuildmcp__describe_ui()         # Get UI hierarchy
mcp__xcodebuildmcp__tap({id: "..."})      # Tap by ID
mcp__xcodebuildmcp__tap({label: "..."})   # Tap by label
mcp__xcodebuildmcp__type_text({text:""})  # Enter text
mcp__xcodebuildmcp__gesture({preset:""})  # Gestures
```

### Simulator Control
```
mcp__xcodebuildmcp__list_sims()           # List simulators
mcp__xcodebuildmcp__boot_sim()            # Boot simulator
mcp__xcodebuildmcp__open_sim()            # Open Simulator app
mcp__xcodebuildmcp__set_sim_appearance({mode: "dark"})
```

### Documentation Lookup
```
mcp__apple-docs__search_apple_docs({query: "SwiftUI List"})
mcp__apple-docs__search_wwdc_content({query: "@Observable"})
mcp__cupertino__search({query: "NavigationStack"})
```

---

## 🚀 Ready to Start!

**Restart Claude Code** to load the new skills, then begin with:

```
1. Scaffold the iOS project
2. Create SwiftData models
3. Convert home-dashboard.html → HomeView.swift
4. Build, run, screenshot, iterate
5. Repeat for each screen
```

The MCP tools will enable rapid iteration with visual feedback at every step.

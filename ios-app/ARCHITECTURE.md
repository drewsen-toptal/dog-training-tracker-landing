# PuppyPro iOS App - Architecture Plan

## Table of Contents
1. [Video Implementation Strategy](#video-implementation-strategy)
2. [Backend & Database Architecture](#backend--database-architecture)
3. [Implementation Phases](#implementation-phases)

---

## Video Implementation Strategy

### Current State
The app has a video placeholder in `CommandDetailView.swift` (lines 169-217) that displays:
- Dark gradient background
- Play button with "Watch Training Video" text
- Hardcoded "1:24" duration badge
- **No actual video playback functionality**

### Recommended Approach: AVKit with Remote URLs

**Why AVKit over WebView/YouTube:**
- Native iOS experience with system video controls
- Better performance and battery efficiency
- Works with AirPlay and Picture-in-Picture
- No third-party dependencies
- Full control over playback experience
- No YouTube branding/ads

### Implementation Plan

#### 1. Update Command Model
Add video URL support to the Command model:

```swift
// Command.swift
struct Command: Identifiable {
    // ... existing properties
    let videoUrl: String?        // Remote video URL (e.g., CloudFlare Stream, S3)
    let videoDuration: Int?      // Duration in seconds
    let videoThumbnailUrl: String?  // Optional thumbnail
}
```

#### 2. Create VideoPlayerView Component

```swift
import SwiftUI
import AVKit

struct TrainingVideoPlayer: View {
    let videoUrl: URL
    @State private var player: AVPlayer?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
            .onAppear {
                player = AVPlayer(url: videoUrl)
            }
            .onDisappear {
                player?.pause()
            }
    }
}
```

#### 3. Update CommandDetailView Video Section

```swift
@ViewBuilder
private var videoSection: some View {
    if let videoUrlString = command.videoUrl,
       let videoUrl = URL(string: videoUrlString) {
        Button {
            showingVideoPlayer = true
        } label: {
            // Current placeholder UI with real thumbnail
            AsyncImage(url: URL(string: command.videoThumbnailUrl ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                // Current gradient placeholder
            }
            .overlay {
                // Play button overlay
            }
        }
        .fullScreenCover(isPresented: $showingVideoPlayer) {
            TrainingVideoPlayer(videoUrl: videoUrl)
        }
    }
}
```

### Video Hosting Options

| Option | Pros | Cons | Cost |
|--------|------|------|------|
| **CloudFlare Stream** | Fast CDN, adaptive bitrate, simple API | Limited free tier | $5/1000 min watched |
| **AWS S3 + CloudFront** | Full control, scalable | More setup required | Pay per GB |
| **Bunny.net** | Cheap, fast, easy | Less features | $0.01/GB |
| **Local Bundle** | Works offline, no hosting costs | Increases app size | Free |

**Recommendation:** Start with **local bundled videos** for MVP (12 commands = ~120MB estimated), then migrate to **CloudFlare Stream** when scaling.

### Video Content Requirements

For each of the 12 commands, create:
- **Training demonstration video** (60-90 seconds)
- **Thumbnail image** (16:9 aspect ratio)
- Format: H.264/MP4, 1080p preferred, 720p minimum

---

## Backend & Database Architecture

### Current State: Local-Only with SwiftData

The app currently uses **SwiftData** for local persistence:
- `Dog` model - Dog profiles with name, breed, birthDate, photo
- `TrainingSession` model - Training session records
- `CommandProgress` model - Progress tracking per command

**This works well for single-device usage but has limitations.**

### When Backend is Needed

A backend becomes necessary when you want:

| Feature | Requires Backend? | Complexity |
|---------|------------------|------------|
| Multi-device sync | Yes | High |
| User accounts/authentication | Yes | Medium |
| Video hosting | Yes | Low |
| Push notifications | Yes | Medium |
| Analytics/insights | Yes | Low |
| Subscription/payments | Yes | High |
| Leaderboards/social | Yes | High |
| Offline-first + sync | Yes | High |

### Recommended Architecture

#### Option A: Firebase (Fastest to Market)

```
┌─────────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                     │
├─────────────────────────────────────────────────────────┤
│  SwiftData (Local Cache)  │  Firebase SDK               │
├───────────────────────────┴─────────────────────────────┤
│                    Firebase Services                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Auth        │  │ Firestore   │  │ Storage     │     │
│  │ (Users)     │  │ (Data)      │  │ (Videos)    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │ Cloud Msg   │  │ Analytics   │                       │
│  │ (Push)      │  │ (Insights)  │                       │
│  └─────────────┘  └─────────────┘                       │
└─────────────────────────────────────────────────────────┘
```

**Pros:** Quick setup, scales automatically, good iOS SDK, free tier
**Cons:** Vendor lock-in, costs can spike, less control

#### Option B: Supabase (Open Source Alternative)

```
┌─────────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                     │
├─────────────────────────────────────────────────────────┤
│  SwiftData (Local)  │  Supabase Swift Client            │
├─────────────────────┴───────────────────────────────────┤
│                    Supabase Platform                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Auth        │  │ PostgreSQL  │  │ Storage     │     │
│  │ (Users)     │  │ (Data)      │  │ (Files)     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │ Edge Funcs  │  │ Realtime    │                       │
│  │ (Logic)     │  │ (Sync)      │                       │
│  └─────────────┘  └─────────────┘                       │
└─────────────────────────────────────────────────────────┘
```

**Pros:** PostgreSQL (real database), open source, self-hostable, predictable pricing
**Cons:** Smaller ecosystem, Swift SDK is newer

#### Option C: Custom Backend (Cloudflare Workers + D1)

```
┌─────────────────────────────────────────────────────────┐
│                    iOS App (SwiftUI)                     │
├─────────────────────────────────────────────────────────┤
│  SwiftData (Local)  │  Custom API Client                │
├─────────────────────┴───────────────────────────────────┤
│                  Cloudflare Platform                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Workers     │  │ D1          │  │ R2          │     │
│  │ (API)       │  │ (SQLite DB) │  │ (Storage)   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │ KV          │  │ Stream      │                       │
│  │ (Cache)     │  │ (Videos)    │                       │
│  └─────────────┘  └─────────────┘                       │
└─────────────────────────────────────────────────────────┘
```

**Pros:** Ultra-low latency (edge), very cheap, full control
**Cons:** More DIY, need to build auth, more code

### Recommended: Supabase + CloudFlare Stream

Best balance of:
- Real PostgreSQL database
- Built-in authentication
- Good Swift client
- Open source / portable
- CloudFlare Stream for videos (better video CDN than Supabase Storage)

### Database Schema Design

```sql
-- Users (managed by Supabase Auth)
-- Dogs
CREATE TABLE dogs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    breed TEXT,
    birth_date DATE,
    photo_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Training Sessions
CREATE TABLE training_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dog_id UUID REFERENCES dogs(id) ON DELETE CASCADE,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Session Commands (commands practiced in a session)
CREATE TABLE session_commands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES training_sessions(id) ON DELETE CASCADE,
    command_id TEXT NOT NULL, -- References static Command.id
    success_count INT DEFAULT 0,
    needs_work_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Command Progress (aggregated per dog per command)
CREATE TABLE command_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dog_id UUID REFERENCES dogs(id) ON DELETE CASCADE,
    command_id TEXT NOT NULL,
    total_attempts INT DEFAULT 0,
    total_successes INT DEFAULT 0,
    mastery_level INT DEFAULT 0, -- 0-100
    last_practiced_at TIMESTAMPTZ,
    UNIQUE(dog_id, command_id)
);

-- Enable Row Level Security
ALTER TABLE dogs ENABLE ROW LEVEL SECURITY;
ALTER TABLE training_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_commands ENABLE ROW LEVEL SECURITY;
ALTER TABLE command_progress ENABLE ROW LEVEL SECURITY;

-- RLS Policies (users can only access their own data)
CREATE POLICY "Users can CRUD their own dogs"
    ON dogs FOR ALL USING (auth.uid() = user_id);
```

### Sync Strategy: Offline-First

```
┌────────────────────────────────────────────────────────┐
│                     iOS App                             │
│  ┌─────────────────┐        ┌────────────────────────┐ │
│  │   SwiftData     │◄──────►│   SyncEngine           │ │
│  │   (Local DB)    │        │   (Conflict Resolution)│ │
│  └─────────────────┘        └───────────┬────────────┘ │
│                                         │              │
└─────────────────────────────────────────┼──────────────┘
                                          │
                                          ▼
                              ┌───────────────────────┐
                              │   Supabase Backend    │
                              │   (Source of Truth)   │
                              └───────────────────────┘
```

1. **Writes go to SwiftData first** (instant response)
2. **SyncEngine queues changes** for upload
3. **Background sync** when network available
4. **Conflict resolution**: Last-write-wins with timestamps

---

## Implementation Phases

### Phase 1: MVP (Current + Videos)
**Timeline: 1-2 weeks**

- [ ] Add `videoUrl` field to Command model
- [ ] Implement AVKit video player
- [ ] Bundle 3-4 sample training videos locally
- [ ] Update CommandDetailView to play videos
- [ ] Complete Settings navigation (Notifications, Goals)

### Phase 2: Basic Backend
**Timeline: 2-3 weeks**

- [ ] Set up Supabase project
- [ ] Implement user authentication (Apple Sign In)
- [ ] Create database schema
- [ ] Build API client in Swift
- [ ] Sync dogs and training data

### Phase 3: Cloud Videos
**Timeline: 1-2 weeks**

- [ ] Set up CloudFlare Stream account
- [ ] Upload all 12 training videos
- [ ] Update Command model with video URLs
- [ ] Add video caching/preloading

### Phase 4: Advanced Features
**Timeline: 3-4 weeks**

- [ ] Push notifications for training reminders
- [ ] Spaced repetition algorithm for "Due for Review"
- [ ] Progress analytics dashboard
- [ ] Multi-dog support enhancements
- [ ] Subscription/premium features (optional)

---

## Cost Estimates (Monthly)

### MVP (Local-only)
- App Store: $99/year
- **Total: ~$8/month**

### With Backend (100 users)
- Supabase: $0 (free tier)
- CloudFlare Stream: ~$5
- **Total: ~$13/month**

### With Backend (1,000 users)
- Supabase: $25
- CloudFlare Stream: ~$20
- **Total: ~$53/month**

### With Backend (10,000 users)
- Supabase: $25-75
- CloudFlare Stream: ~$100
- Push notifications: ~$10
- **Total: ~$143-193/month**

---

## Next Steps

1. **Decide on video approach**: Local bundle vs. hosted
2. **Decide if backend is needed for v1**: Can ship without it
3. **Create video content**: 12 training demonstration videos
4. **Implement video player**: ~2-4 hours of development
5. **If backend needed**: Start Supabase setup

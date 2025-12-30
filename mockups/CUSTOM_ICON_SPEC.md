# Puppy PRO Custom Icon Design Specification

## Design Philosophy
Premium, hand-crafted feel that stands out from emoji-based competitors. Icons should feel warm, approachable, and professionally designed - like Headspace, Calm, or Duolingo quality.

---

## Style Guidelines

### Visual Style
- **Aesthetic**: Soft 3D with subtle gradients (not flat, not skeuomorphic)
- **Corners**: Rounded, friendly feel
- **Colors**: Brand palette (teal primary, amber accent, soft shadows)
- **Stroke**: None - filled shapes only
- **Background**: Transparent PNG or on brand-colored circles

### Color Palette (for prompts)
- **Primary Teal**: `#2DD4BF` (oklch 0.55 0.15 165)
- **Amber Accent**: `#F59E0B` (oklch 0.75 0.14 55)
- **Success Green**: `#10B981` (oklch 0.65 0.18 145)
- **Soft White**: `#F8FAFC`
- **Dark Text**: `#1E293B`

---

## Icons to Generate

### 1. Training Command Icons (44x44px, 72x72px)

| Command | Description for Generation |
|---------|---------------------------|
| **Sit** | Dog silhouette in sitting position, side view, teal gradient, soft 3D style |
| **Stay** | Open palm hand gesture, stop motion, warm skin tone with teal accent |
| **Come** | Beckoning hand with motion lines, welcoming gesture |
| **Down** | Dog lying down on cushion/mat, relaxed pose, cozy feeling |
| **Leash Walking** | Dog and leash in harmony, walking motion, teal leash |
| **Door Manners** | Dog sitting calmly by door frame, patient pose |
| **Stop Barking** | Peaceful dog face, serene expression, quiet vibes |
| **Nipping** | Playful dog with toy/bone, redirect energy concept |
| **Stop Jumping** | Four paw prints in square formation, "four on floor" |
| **House Training** | Cute house icon with dog silhouette, home sweet home |
| **High Five** | Dog paw meeting human hand, connection moment |
| **Roll Over** | Playful dog mid-roll, happy expression |

### 2. App Icon (1024x1024px)

**Concept**: Abstract dog silhouette or paw integrated with training/learning motif
**Style**:
- Teal-to-amber gradient background
- White or light icon element
- Simple, recognizable at small sizes
- No text
- Premium, App Store ready

**Prompt Direction**:
> "App icon for dog training app, abstract friendly dog face silhouette, teal to amber gradient background, soft 3D style, minimalist, premium iOS app icon quality, no text, rounded square safe area"

### 3. Dog Avatar (200x200px circular)

**Concept**: Friendly illustrated dog face that can represent any breed
**Style**:
- Front-facing, happy expression
- Warm, approachable
- Works as circular crop
- Multiple variations for different "moods" or breeds

**Prompt Direction**:
> "Friendly cartoon dog face portrait, golden retriever style, warm happy expression, soft 3D illustration, teal collar accent, circular avatar crop, white background, Pixar-quality character design"

### 4. Onboarding Hero Illustrations (390x300px)

| Screen | Concept |
|--------|---------|
| **Welcome** | Happy owner and dog together, training bond moment |
| **Dog Profile** | Dog portrait frame with decorative elements |
| **Goals** | Multiple training icons floating, achievement feeling |
| **Ready** | Dog and owner high-five, celebration, confetti |

---

## Midjourney Prompt Templates

### For Command Icons:
```
[description], soft 3D icon style, teal and white color scheme, rounded friendly design, app icon quality, transparent background, 44px size optimized, no text --ar 1:1 --v 6
```

### For App Icon:
```
iOS app icon, [description], soft 3D gradient, teal #2DD4BF to amber #F59E0B, minimalist, premium quality, Apple App Store ready, rounded corners safe area --ar 1:1 --v 6
```

### For Illustrations:
```
[description], soft 3D illustration style, warm friendly aesthetic, teal and amber accent colors, white background, Headspace/Calm app quality, modern minimal --ar 4:3 --v 6
```

---

## Generation Priority

### Phase 1 (MVP Critical)
1. App Icon
2. Dog Avatar (default)
3. Sit icon
4. Stay icon
5. Come icon

### Phase 2 (Launch)
6. Down icon
7. Leash Walking icon
8. Welcome hero illustration

### Phase 3 (Polish)
9. Remaining command icons
10. Onboarding illustrations
11. Additional dog avatar variations

---

## Technical Requirements

- **Format**: PNG with transparency
- **Resolution**: @1x, @2x, @3x for iOS
- **App Icon**: 1024x1024 (Xcode will generate sizes)
- **Command Icons**: 44pt base (132px @3x)
- **Hero Images**: 390pt width (1170px @3x)

---

## Competitor Differentiation

| Competitor | Icon Style | Our Advantage |
|------------|------------|---------------|
| Dogo | Basic flat emojis | Custom 3D illustrations |
| Puppr | Stock icons + emojis | Cohesive branded set |
| Pupford | Generic flat | Premium Headspace-quality |
| Woofz | Mixed emoji/stock | Unified design language |

Our custom icons will immediately signal **premium quality** and **professional craftsmanship** - justifying the one-time purchase over subscription competitors.

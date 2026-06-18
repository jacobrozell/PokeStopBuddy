# Feature: Submission Guide

In-app education that teaches the **Pokémon GO / Niantic Wayfarer nomination flow**, explains
how Waypoint Writer fields map to in-game screens, and helps users pick the right **categories**
and **eligibility tags** before they copy content into the real submission form.

Complements (does not replace) the external [Wayfarer guidelines](https://niantic.helpshift.com/hc/en/21-wayfarer/)
link in Settings.

## Goals

| Job | How the guide helps |
|-----|---------------------|
| "I've never nominated before — what happens?" | Step-by-step process with Pokémon GO screenshots |
| "What does this field mean in the real form?" | Field reference + side-by-side mapping to in-game UI |
| "Which category / eligibility tag should I pick?" | Tag reference with examples and pillar mapping |
| "I drafted content — now what?" | Copy workflow into Pokémon GO preview & upload |

## Non-goals (v1.1)

- Interactive quizzes or reviewer practice (see `FutureIdeas/backlog.md`).
- Live nomination status or Wayfarer API integration.
- Photo capture or pin placement inside Waypoint Writer (deferred to Photo composition
  guidance, v1.1).

## Information architecture

Entry points (all open the same `SubmissionGuideView` hub; deep links scroll to a topic):

```
Submission Library toolbar     →  "Learn" button (book icon)
Settings → Reference section   →  "Submission guide" row (above Wayfarer link)
Submission Editor              →  (?) info buttons on section headers / pickers
Library empty state            →  secondary "Learn how nominations work" link
```

Presentation:

| Idiom | Presentation |
|-------|----------------|
| iPhone | Sheet from library toolbar (`.large` detent) or sheet from editor contextual help |
| iPad | Same sheet from library toolbar (`.large` detent) |
| Settings | Sheet from the guide row (same hub as library) |

No new tab bar. Guide is reference content, not a primary destination.

## Screens & content modules

### 1. Guide hub (`SubmissionGuideView`)

Scrollable table-of-contents landing page.

| Section card | Leads to |
|--------------|----------|
| Nomination process | `GuideTopic.process` |
| Field reference | `GuideTopic.fields` |
| Categories & tags | `GuideTopic.categories` |
| Eligibility pillars | `GuideTopic.eligibility` |
| Photos & location | `GuideTopic.photos` |
| Copy into Pokémon GO | `GuideTopic.copyWorkflow` |

Each card: title, one-line summary, SF Symbol, chevron. Cards are buttons ≥ 44 pt.

Optional **"Open Wayfarer guidelines"** footer link (same URL as Settings).

### 2. Topic detail (`GuideTopicDetailView`)

Shared template for every topic:

```
┌─────────────────────────────────────┐
│  Title                              │
│  Short intro (1–2 sentences)        │
├─────────────────────────────────────┤
│  [Screenshot carousel / hero image] │  ← optional per step
│  Caption (what screen this is)      │
├─────────────────────────────────────┤
│  Body sections (headings + prose)   │
│  • Bullet tips                      │
│  • Callout cards (do / don't)       │
├─────────────────────────────────────┤
│  "In Waypoint Writer" callout        │  ← maps to editor fields
│  Related topics (chips)             │
└─────────────────────────────────────┘
```

On iPad / wide width: screenshot left (~40%), text right (~60%). On phone: stacked.

### 3. Topic content (authoritative copy outline)

#### `process` — Nomination process

Maps the official Pokémon GO flow ([Niantic help](https://niantic.helpshift.com/hc/en/6-pokemon-go/faq/41-contributing-to-the-pokemon-go-map/)):

| Step | In Pokémon GO | Waypoint Writer role |
|------|---------------|---------------------|
| 1 | Main menu → Settings → Uploads → **New PokéStop** | — (in-game only) |
| 2 | **Set location** on map; confirm pin | — (in-game only); tip: pin accuracy matters |
| 3 | **Main photo** of the object | — (v1.1 photo guidance) |
| 4 | **Supporting photo** of surroundings | — (v1.1 photo guidance) |
| 5 | **Title** and **Description** | ✅ Generate & edit here; copy when ready |
| 6 | **Categorize** this location | ✅ Pick `WayspotCategory`; informs generator tone |
| 7 | **Preview** and confirm | Review generated text before copying |
| 8 | **Supporting information** (why eligible) | ✅ `EligibilityCriterion` + supporting statement |
| 9 | Upload now / later → **community review** | — (in-game / Wayfarer web) |

Screenshots to include (see Asset catalog):

- `guide.process.menu` — Settings → Uploads entry
- `guide.process.map` — Pin placement
- `guide.process.mainPhoto` — Main photo capture
- `guide.process.supportingPhoto` — Context photo
- `guide.process.titleDescription` — Title & description form
- `guide.process.category` — Category picker
- `guide.process.preview` — Preview screen
- `guide.process.supporting` — Supporting information / eligibility
- `guide.process.upload` — Upload now / later

Prerequisites callout: Level 35+, Wayfarer onboarding quiz completed (requirements may
change — link to official FAQ, don't hard-code as permanent).

#### `fields` — Field reference

| Waypoint Writer input | Pokémon GO / Wayfarer field | Limit | Notes |
|----------------------|----------------------------|-------|-------|
| Place name | (drafting aid; becomes Title) | — | Raw name before title-case generation |
| Category (`WayspotCategory`) | Step 6 category tag | pick one | Drives description phrasing |
| Writing style (`GenerationStyle`) | — | app-only | Tone for generated text, not submitted |
| Key features | — | app-only | Bullets fed into description generator |
| Eligibility (`EligibilityCriterion`) | Step 8 pillar selection | ≥ 1 | At least one required for quality |
| Location hint | Supporting information | ≤ 500 chars | "How reviewers can find it" |
| Access notes | Supporting information | ≤ 500 chars | Pedestrian / public access |
| Title | Title | 100 | `GenerationLimits.titleMax` |
| Description | Description | 250 | `GenerationLimits.descriptionMax` |
| Supporting statement | Additional information | 500 (GO) / 3000 (Wayfarer web) | `GenerationLimits.supportingMax` targets GO |

Screenshot: `guide.process.titleDescription` annotated with callout lines to each field.

#### `categories` — Categories & tags

Explains **Wayspot category tags** (Step 6) vs Waypoint Writer's `WayspotCategory`.

| `WayspotCategory` | Typical in-game examples | Primary pillar(s) | Example key features |
|-------------------|-------------------------|-------------------|----------------------|
| `publicArt` | Mural, sculpture | Historic / Cultural, Social | "hand-painted", "2019 commission" |
| `historicalMarker` | Plaque, interpretive sign | Historic / Cultural | year erected, event commemorated |
| `monument` | Statue, war memorial | Historic / Cultural | dedication date, material |
| `building` | Notable architecture | Historic / Cultural, Social | architect, year built |
| `placeOfWorship` | Church, temple (public) | Historic / Cultural, Social | denomination, landmark status |
| `library` | Public library, Little Free Library | Historic / Cultural, Social | hours, founding year |
| `park` | Neighborhood park | Exercise, Social | acreage, amenities |
| `playground` | Public playground | Exercise, Social | equipment type, surface |
| `trailhead` | Trail marker, trailhead sign | Exercise, Exploration | trail name, length |
| `sportsField` | Ball field, court | Exercise, Social | sport, public hours |
| `fountain` | Public fountain | Social, Exploration | year installed, plaza name |
| `garden` | Community garden, botanical | Exercise, Exploration | public access, plantings |
| `localBusiness` | Independent shop (careful) | Social | local landmark status only |
| `other` | When nothing fits | varies | explain in features + supporting |

UI: filterable grid of `TagChip` rows (category name + pillar badges). Tapping a chip
expands an example blurb. **Not** a picker — education only.

Screenshot: `guide.process.category` with annotation mapping a few visible GO categories to
our enum.

Note: Pokémon GO also offers free-text "Other" category; Waypoint Writer uses `other` and
relies on key features + description for specificity.

#### `eligibility` — Eligibility pillars

The three Wayfarer pillars ([eligibility FAQ](https://niantic.helpshift.com/hc/en/21-wayfarer/faq/2770-eligibility-criteria/)):

| `EligibilityCriterion` | Official pillar | Pick when… | Example places |
|------------------------|-----------------|------------|----------------|
| `historicCultural` | Great place for **exploration** | Teaches history, culture, or local identity | Markers, museums, art, monuments |
| `exercise` | Great place for **exercise** | Encourages walking, sports, outdoor activity | Parks, trails, sports fields |
| `socialExploration` | Great place to be **social** | Gathering spot, entertainment, community hub | Plazas, libraries, fountains |

Rules to teach:

- **At least one** pillar required; multiple allowed when genuinely true.
- Eligibility ≠ automatic acceptance (acceptance / rejection criteria still apply).
- Do **not** mention Pokémon GO, beg for approval, or cite game benefits in supporting text.

Screenshot: `guide.process.supporting` showing the pillar selection UI.

Common mistakes callout (ties to Quality Coach): schools (K–12), private residences,
temporary objects, emergency services, duplicates too close to existing Wayspots.

#### `photos` — Photos & location

Brief module (full photo composition spec is v1.1). Teaches:

- Pin must be on the **object**, not the photographer's location.
- Main photo: clear, well-lit, close-up of the nominated object; no faces/license plates.
- Supporting photo: shows surroundings so reviewers can verify location.
- Wayfarer **web** submission allows up to 5 supporting photos (optional mention).

Screenshots: `guide.process.map`, `guide.process.mainPhoto`, `guide.process.supportingPhoto`.

Cross-link: "Photo composition guidance" placeholder row (disabled until v1.1 ships).

#### `copyWorkflow` — Copy into Pokémon GO

Step-by-step after drafting in Waypoint Writer:

1. Tap **Generate content** in the editor.
2. Review Quality Coach — resolve blockers.
3. Fine-tune text or regenerate.
4. Tap **Copy all** (or Share).
5. In Pokémon GO, reach Step 5 / 8 and **paste** into Title, Description, Supporting.
6. Complete photos, pin, category (if not already set in-game), preview, upload.

Screenshot: `guide.process.preview` + editor Copy all button (app screenshot, not GO).

Tip: Upload Later when signal is weak.

## Screenshot assets

### Policy

- Screenshots are **educational fair-use** references to help users recognize in-game UI.
- Capture on a **personal device** running Pokémon GO; use generic/public locations only.
- **Redact** trainer name, email, map coordinates, and any PII before committing.
- Include `docs/guide-screenshot-checklist.md` for contributors (capture steps, redaction,
  alt-text template). Do not hotlink third-party images.
- If Niantic requests removal, delete assets and fall back to text-only + official links.

### Asset catalog

```
Resources/Assets.xcassets/
  guide.process.menu.imageset/
  guide.process.map.imageset/
  …
```

| Asset ID | Alt text (en) |
|----------|---------------|
| `guide.process.menu` | Pokémon GO Settings screen with Uploads and New PokéStop highlighted |
| `guide.process.map` | Map view with nomination pin placed on a landmark |
| `guide.process.mainPhoto` | Camera view capturing the main photo of a nomination |
| `guide.process.supportingPhoto` | Camera view for the supporting surroundings photo |
| `guide.process.titleDescription` | Nomination form showing Title and Description fields |
| `guide.process.category` | Category picker with tags such as Library and Public Art |
| `guide.process.preview` | Preview screen summarizing nomination details before submit |
| `guide.process.supporting` | Supporting information screen with eligibility options |
| `guide.process.upload` | Upload now or upload later confirmation |

Provide `@2x` and `@3x` PNG. Dark-mode variants when GO UI differs materially.

### In-app screenshot component

`GuideScreenshot` — bundled image when present, else `GuideSchematicScreenshot` wireframe + caption.

- Decorative frame (rounded rect, subtle shadow) using `Theme.Radius.md`.
- `accessibilityLabel` = alt text; caption visible below.
- Schematics use `guide.schematic.*` keys; replace with bundled `guide.process.*` images when captured.
- Pinch-to-zoom optional (v1.2); v1.1 static image only.

## Domain & content layer

Static content only — no SwiftData, no network.

```swift
/// Stable topic identifiers for deep links and UI tests.
enum GuideTopic: String, CaseIterable, Identifiable {
    case process, fields, categories, eligibility, photos, copyWorkflow
}

struct GuideArticle: Sendable {
    let topic: GuideTopic
    let title: String          // L10n key
    let intro: String
    let sections: [GuideSection]
    let screenshotIDs: [String] // asset names, optional
    let relatedTopics: [GuideTopic]
    let appCalloutKey: String?   // "In Waypoint Writer…"
}

struct GuideSection: Sendable {
    let heading: String
    let body: String
    let bullets: [String]
    let callout: GuideCallout?  // .do / .dont / .tip
}
```

`GuideContent` (or `GuideCatalog`) lives in **Domain** or **Support** as pure structs +
`L10n` keys. Features import the catalog; no business logic in views.

`GuideTopic+EditorMapping` maps editor fields to topics for contextual (?) buttons:

| Editor anchor | Topic |
|---------------|-------|
| About section header | `fields` |
| Category picker | `categories` |
| Eligibility editor | `eligibility` |
| Key features | `fields` (subsection) |
| Generated section header | `copyWorkflow` |
| Location / access fields | `photos` + `fields` |

## UI components (Features/SubmissionGuide/)

| View | Responsibility |
|------|----------------|
| `SubmissionGuideView` | Hub TOC |
| `GuideTopicDetailView` | Renders one `GuideArticle` |
| `GuideLibrarySheet` | Library toolbar, empty state, and Settings guide row |
| `GuideTopicSheet` | Single-topic sheet from editor info buttons |
| `GuideScreenshot` | Bundled image or schematic + caption |
| `GuideSchematicScreenshot` | Illustrated wireframes when GO assets missing |
| `GuideCalloutCard` | Do / don't / tip styling |
| `GuideCategoryGrid` | Category reference chips |
| `GuidePillarCard` | Eligibility pillar explainer |
| `GuideAppCallout` | Highlighted "In Waypoint Writer" box |

Reuse `TagChip`, `Card`, `PrimaryButton` from DesignSystem where applicable.

## ViewModel

`SubmissionGuideViewModel` (`@Observable`, optional for v1.1):

- `selectedTopic: GuideTopic?` for programmatic navigation / deep link.
- `scrollToSectionID` when opened from editor contextual help.
- No async work.

## Accessibility

- Hub cards: `guide.hub.<topic>` identifiers.
- Detail root: `guide.detail.<topic>`.
- Screenshots: meaningful `accessibilityLabel` (alt text), not hidden as decorative.
- Callouts: severity conveyed by symbol + heading, not color alone.
- Dynamic Type: body text uses semantic styles; screenshot width scales, never clips text.
- Related-topic chips ≥ 44 pt.

Add rows to `specs/accessibility.md` tracker when implemented.

## Localization

All user-visible strings via `L10n` under `guide.*` prefix. Article bodies can start in
`Localizable.strings` (v1.1); if copy grows large, move to `GuideArticles.en.json` bundled
resource with parity test.

New keys in the same PR as UI.

## Testing

| Layer | Coverage |
|-------|----------|
| Unit | `GuideCatalog` has an article for every `GuideTopic`; category → pillar mapping sanity |
| UI | Open hub from library → open `process` → screenshot visible; editor (?) opens `categories` |
| Snapshot | One hub + one detail (optional) |

## App shell updates

- Library toolbar: `guide.openButton` (book icon), left of Settings gear or grouped in menu.
- Settings: new row `settings.guide` in Reference section.
- Editor: `InfoButton` on section headers (minimal, no clutter).

Update `specs/app-shell.md` when implemented.

## Verification

- Target release: v1.1
- Last verified: 2026-06-17
- Commit: (guide schematic wireframes)
- Primary code paths: Features/SubmissionGuide/, Support/Guide/, Resources/Assets.xcassets, Tests/Unit/GuideCatalogTests.swift, Tests/UI/SubmissionGuideUITests.swift

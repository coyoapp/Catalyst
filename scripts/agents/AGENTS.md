# Catalyst Component Agent

The component agent scaffolds new Catalyst components from a plain-English brief. It reasons about what the component needs, audits tokens, generates source files for both iOS and Android, and produces a review + parity report.

There are two ways to run it. Both require a `brief.md` written first. Both produce identical output.

---

## Before You Start (Required for Both Paths)

### Write brief.md

Create the output directory and write a plain-English description of the component:

```bash
mkdir -p scripts/agents/output/{component}
# then write scripts/agents/output/{component}/brief.md
```

Example for a badge component:

```markdown
A small status indicator that shows counts, a text label, or a dot.
Has primary, danger, success, warning, and info color variants.
Display only — not tappable. Used in list rows, nav items, and avatars.
No multiple sizes — always compact. Primary variant supports accent palette
for whitelabeling.
```

The brief is the source of truth. The more specific you are, the better the agent's decisions. Include:
- What the component **is** and where it appears
- Whether it is **tappable** or display-only
- What **content** it shows (text, count, icon, dot, etc.)
- What **color variations** it has
- Whether there are **distinct sizes**
- Any **constraints** ("always circular", "no loading state")
- Open questions for the design team

---

## Path 1 — OpenCode Command (Primary)

Uses whatever model is active in your OpenCode session. No additional API keys needed.

```
/generate-component badge
```

Type this in the OpenCode TUI. The command reads `brief.md`, reasons about the component using the active model, audits tokens, scaffolds files, and produces review + parity reports — all in one session.

---

## Path 2 — Node.js Fallback

Use this when OpenCode is unavailable. Requires a GitHub PAT.

### One-time setup

```bash
# scripts/agents/.env
GITHUB_TOKEN=ghp_your_token_here
```

Create a Personal Access Token at [github.com/settings/tokens](https://github.com/settings/tokens) with **Models: Read** scope. Your GitHub Copilot subscription covers usage — no separate vendor account needed.

### Run

```bash
node scripts/agents/component-agent.js --component=badge
```

Optional flags:

```
--model <model>      Override LLM model (default: gpt-4o)
                     Options: claude-sonnet-4-5, gpt-4o-mini
--skip-scaffold      Reasoning and review only, no file generation
                     Useful for reviewing existing files
```

---

## Output

Both paths write to `scripts/agents/output/{component}/`:

```
brief.md         ← you write this before running
decisions.json   ← machine-readable decisions (consumed by scaffolder)
decisions.md     ← human-readable reasoning — read this first
token-audit.md   ← token cross-reference result
review.md        ← pattern + token review
parity.md        ← iOS ↔ Android alignment report
Cat*.swift       ← generated iOS source files
Cat*.kt          ← generated Android source files
```

**Start with `decisions.md`.** It shows the agent's reasoning. If something is wrong, correct it before looking at the generated code.

---

## How the Agent Decides

The agent reads the brief and makes all structural decisions. You do not fill in a JSON contract or spec file.

| Decision | How the agent chooses |
|---|---|
| **Profile** (interactive vs display) | "not tappable" → display; "tappable / tap / action" → interactive |
| **States** | display: normal + disabled only; interactive: adds pressed + focused; loading only if brief mentions async |
| **Variants** | Named color options in the brief |
| **Sizes** | Only if brief names distinct presets |
| **Content model** | `label` if only text; `enum` if 2+ structurally different content types |
| **Accent palette** | Enabled if component has a primary or brand variant |
| **Android file count** | interactive: up to 5 files; display: 3–4 files; no file if it adds no value |

---

## Correcting Wrong Decisions

**Option 1 — Edit brief and re-run** (preferred when the brief was unclear):

```bash
# Edit scripts/agents/output/{component}/brief.md with more detail
# Then re-run via /generate-component or node command
```

**Option 2 — Edit generated files directly** (when structure is right but details are off):
Edit files in `output/{component}/` directly before moving to source.

---

## Token Gaps

If the agent finds tokens that do not exist in `tokens/src/`, it will halt and list them:

```
── HALTED: 2 missing token(s) ──

• badge dot size: component.badge.size.dot
• badge count font: component.badge.typography.count
```

**Do not add these manually.** Token source files are generated from Figma via Style Dictionary. Share the missing list with the design team. If a different existing token should be used, update `brief.md` and re-run.

---

## Moving to Source

Once `review.md` and `parity.md` show no blocking issues:

| Platform | Destination |
|---|---|
| iOS | `iOS/Catalyst/Sources/Catalyst/Components/<PascalName>s/` |
| Android | `android/catalyst/src/main/java/com/haiilo/catalyst/components/<componentname>/` |

**After moving:**
1. Add to the Demo app and verify it renders correctly
2. Create Jira tasks for iOS and Android, labelled `catalyst-mobile`
3. Write `docs/ios/<component>.md` and `docs/android/<component>.md` following `docs/ios/button.md`
4. Open a PR — branch: `feat/<component>-component`
5. Commit: `feat(<component>): add Cat<Component> component`
6. Requires `@coyoapp/mobile-design-core` review before merge

---

## Project Structure

```
scripts/
  agents/
    component-agent.js     Node.js fallback — full standalone LLM agent
    output/                Generated files (gitignored)
      {component}/
        brief.md           ← you write this
        decisions.json     ← machine-readable, shared between both paths
        decisions.md       ← human-readable reasoning
        token-audit.md
        review.md
        parity.md
        Cat*.swift
        Cat*.kt

  tools/                   Pure functions — no LLM, called by both paths
    spec-parser.js         Token path utilities
    spec-validator.js      Validates decisions object
    token-auditor.js       Cross-references tokens against tokens/src/
    scaffolder.js          Renders Handlebars templates

  templates/               Handlebars templates, profile-aware
    iOS (6):               Style, Builder, Theme × interactive + display
    Android (8):           Enums, StateStyle, Colors, Defaults×2, Config, Composable×2

.opencode/commands/
  generate-component.md    OpenCode /generate-component command
```

---

## Reference Components

The agent uses these as pattern references during review:

| Pattern | iOS | Android |
|---|---|---|
| Interactive | `CatButtonStyle.swift`, `CatButtonBuilder.swift`, `CatSegmentedControlStyle.swift`, `CatSegmentedControlBuilder.swift` | `CatButton.kt`, `CatButtonEnums.kt`, `CatButtonStateStyle.kt`, `CatSegmentedControl.kt`, `CatSegmentedControlEnums.kt`, `CatSegmentedControlDefaults.kt` |
| Display | `CatAlertStyle.swift`, `CatAlertBuilder.swift` | `CatAlert.kt`, `CatAlertDefaults.kt` |

---

## Key Rules (enforced automatically)

- No hardcoded hex values — all colors `CatColors.*`, spacing `CatSpacing.*`, etc.
- All public types use the `Cat` prefix
- State priority: `disabled → loading → pressed → hovered (iOS only) → focused → normal`
- No hardcoded `accessibilityLabel` — consuming view sets these
- Android: no Material3 `Surface` — use `Box + clip + background` directly
- Android token names: snake_case (`border_radius_md` not `borderRadiusMd`)
- Hovered state: iOS only — Android omits it

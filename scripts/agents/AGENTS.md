# Catalyst Agent Pipeline

Agents for building and auditing Catalyst Design System components. Each agent is a standalone Node.js script — run them individually or chain them via the orchestrator.

---

## Overview

Building a new component like Badge or TextInput involves repetitive, error-prone work: researching variants, auditing which tokens exist, scaffolding consistent boilerplate, and reviewing the result. These agents handle that burden so you can focus on the design decisions that actually need human judgment.

```
spec-template-agent  →  research-agent  →  spec-validate-agent  →  token-audit-agent  →  scaffold-agent  →  review-agent
   (optional)            (optional)            (required)               (read-only)          (generates)        (optional)
```

**Key rules:**
- Nothing is ever written to `iOS/` or `android/` automatically — generated files land in `output/{component}/` for your review first
- `token-audit-agent` never writes to `tokens/src/` — the design team owns that source
- Every agent can be run standalone, in any order
- The orchestrator is just a convenience wrapper — it does not do anything the individual agents cannot

---

## Setup

```bash
cd scripts/agents
npm install

# Copy the env template and fill in your GitHub token
cp .env.example .env
```

Edit `.env` and add your GitHub Personal Access Token:
```
GITHUB_TOKEN=github_pat_...
```

**How to create the token:**
1. Go to https://github.com/settings/personal-access-tokens/new
2. Give it a name (e.g. `Catalyst agents`) and set an expiry
3. Under **Account permissions**, set **Models** → **Read-only**
4. Click **Generate token** and paste it into `.env`

Your **GitHub Copilot subscription covers the usage** — no separate Anthropic or OpenAI account is needed. The agents call Claude and GPT-4o through the GitHub Models API (`models.inference.ai.azure.com`).

The LLM agents (research, review) require the token. The spec-template, spec-validate, token-audit and scaffold agents have **no API dependency** and work fully offline.

**Optional:** You can also set `MODEL=claude-sonnet-4-5` in `.env` to default to Claude instead of GPT-4o.

---

## Agent Reference

### `spec-template-agent.js` — Canonical spec starter

**What it does:** Creates `output/{component}/spec.md` with a machine-readable JSON contract and human notes section.

```bash
node spec-template-agent.js --component=badge
node spec-template-agent.js --component=badge --force
```

**Output:** `output/badge/spec.md`

**Flags:**
| Flag | Description |
|---|---|
| `--component` | Component name in kebab-case. Required. |
| `--spec` | Custom path to spec.md output. |
| `--force` | Overwrite existing spec.md. |

---

### `research-agent.js` — Optional spec generator

**What it does:** Calls an LLM with your token vocabulary and Catalyst conventions to draft a component spec. Useful as a starting point when you don't have a Figma spec yet.

**When to skip it:** When you have a Figma spec — just write `spec.md` by hand (see the spec format below).

```bash
node research-agent.js --component=badge

# With context to guide the LLM
node research-agent.js --component=badge \
  --context="A small indicator that shows a count or status. Used on avatars and navigation items."
```

**Output:** `output/badge/spec.md`

**Flags:**
| Flag | Description |
|---|---|
| `--component` | Component name in kebab-case. Required. |
| `--context` | Optional description to help the LLM understand the component. |
| `--model` | Override model name (e.g. `claude-sonnet-4-5` for more thorough output). |

---

### `spec-validate-agent.js` — Contract validator

**What it does:** Validates the machine-readable JSON contract in `spec.md` before audit/scaffold. Fails fast with explicit field-level errors.

```bash
node spec-validate-agent.js --component=badge
```

**Output:** `output/badge/spec-validation.md`

**Flags:**
| Flag | Description |
|---|---|
| `--component` | Component name in kebab-case. Required. |
| `--spec` | Custom path to spec.md. Defaults to `output/{component}/spec.md`. |

---

### `token-audit-agent.js` — Token availability checker

**What it does:** Reads `spec.md` and all token files in `tokens/src/`, then produces a report showing which tokens exist, which are missing, and naming suggestions.

**No API key required. Read-only. Safe to run at any time.**

```bash
node token-audit-agent.js --component=badge

# Point to a custom spec location
node token-audit-agent.js --component=badge --spec=~/Desktop/badge-spec.md

# Run without a spec — produces a full token inventory instead
node token-audit-agent.js --component=badge
```

**Output:** `output/badge/token-audit.md`

The report has four sections:
- **✅ Exists** — token is in `tokens/src/`, confirmed
- **⚠️ Fuzzy match** — path in spec doesn't match exactly but a close token was found; verify it's the right one
- **❓ Ambiguous** — multiple tokens match; you need to pick one
- **❌ Missing** — not in `tokens/src/`; share with the design team before proceeding

**Flags:**
| Flag | Description |
|---|---|
| `--component` | Component name in kebab-case. Required. |
| `--spec` | Custom path to spec.md. Defaults to `output/{component}/spec.md`. |

---

### `scaffold-agent.js` — File generator

**What it does:** Reads `spec.md` + `token-audit.md` (both optional — falls back to defaults) and generates all 5 component files using Handlebars templates grounded in the Button component's exact pattern.

**No API key required.**

```bash
node scaffold-agent.js --component=badge

# For a component with icon/text content variants
node scaffold-agent.js --component=chip --has-content-enum

# Custom sizes
node scaffold-agent.js --component=avatar \
  --sizes="extraSmall,small,medium,large" \
  --default-size="medium"

# Include a borderConfig variant in the theme extension
node scaffold-agent.js --component=tag --has-border-variant
```

**Output — staged in `output/badge/`:**
| File | Purpose | Move to |
|---|---|---|
| `CatBadgeStyle.swift` | State machine types + `ViewModifier` | `iOS/Catalyst/Sources/Catalyst/Components/Badges/` |
| `CatBadgeBuilder.swift` | Layout helper + public `CatBadge` view | `iOS/Catalyst/Sources/Catalyst/Components/Badges/` |
| `CatTheme+Badge.swift` | Theme config extension | `iOS/Catalyst/Sources/Catalyst/Theme/` |
| `Badge.kt` | Android Compose skeleton | `android/catalyst/src/main/java/com/haiilo/catalyst/components/` |
| `manifest.json` | Internal file list used by review-agent | _(do not move)_ |

**Flags:**
| Flag | Description | Default |
|---|---|---|
| `--component` | Component name. Required. | |
| `--has-content-enum` | Generate a `Cat{Name}Content` enum (for icon/text variants) | false |
| `--has-border-variant` | Add `borderConfig` to the theme extension | false |
| `--sizes` | Comma-separated size case names | `small,medium` |
| `--default-size` | Default size case name | `small` |
| `--spec` | Custom path to spec.md | `output/{component}/spec.md` |

---

### `review-agent.js` — Automated code review

**What it does:** Sends the generated files, the spec, and the Button component (as reference) to an LLM for a structured code review covering token usage, pattern consistency, accessibility, and Android completeness.

```bash
node review-agent.js --component=badge
```

**Output:** `output/badge/review.md`

The review covers:
- Overall assessment (ready to move to source vs needs work)
- Token usage (any hardcoded values? wrong token references?)
- Pattern consistency vs Button
- State machine completeness
- Accessibility (44pt minimum touch targets, VoiceOver)
- Android TODO markers and unblocking steps
- Specific line-level suggestions
- Pre-merge checklist

**Flags:**
| Flag | Description |
|---|---|
| `--component` | Component name. Required. |
| `--model` | Override model name. Default: `gpt-4o`. Other options: `claude-sonnet-4-5`, `gpt-4o-mini`. |

---

### `orchestrator.js` — Chain runner

Runs agents in sequence. Each step's output feeds the next.

```bash
# Full pipeline (research → validate → audit → scaffold → review)
node orchestrator.js --component=badge

# Skip research (you already have a spec.md contract)
node orchestrator.js --component=badge --skip-research

# Skip validation (not recommended)
node orchestrator.js --component=badge --skip-validate

# Skip both optional LLM steps (audit + scaffold only — fully offline)
node orchestrator.js --component=badge --skip-research --skip-review

# Run only one agent
node orchestrator.js --component=badge --only=template
node orchestrator.js --component=badge --only=validate
node orchestrator.js --component=badge --only=audit
node orchestrator.js --component=badge --only=scaffold
node orchestrator.js --component=badge --only=review

# Pass scaffold flags through
node orchestrator.js --component=chip \
  --skip-research \
  --has-content-enum \
  --sizes="small,medium,large"
```

---

## Workflows

### Workflow A — "I have a Figma spec"

This is the most common scenario.

**Step 1: Create the spec template**

```bash
cd scripts/agents
node spec-template-agent.js --component=badge
```

Fill `scripts/agents/output/badge/spec.md` (JSON contract first, human notes second).

**Step 2: Validate the spec contract**

```bash
node spec-validate-agent.js --component=badge
```

**Step 3: Run the token audit**

```bash
node token-audit-agent.js --component=badge
```

Open `output/badge/token-audit.md`. Check for ❌ missing tokens. If any are missing, share them with the design team and wait before proceeding.

**Step 4: Scaffold once all tokens are green**

```bash
node scaffold-agent.js --component=badge
```

**Step 5: Review the generated files**

Open each file in `output/badge/` and read through them. The scaffold gives you correct structure and token wiring — but it doesn't know your specific visual design decisions (e.g. exact corner radius for a badge vs a button, or whether a badge has a pressed state at all).

Then run the review agent:
```bash
node review-agent.js --component=badge
```

Read `output/badge/review.md`. Fix anything flagged as blocking.

**Step 6: Edit generated files as needed**

All the heavy lifting is done. What you typically need to edit:
- **`CatBadgeStyle.swift`**: Adjust `CatStateProperties` fields to what this component actually needs (e.g. a non-interactive badge doesn't need `hasSecondaryFocusRing`)
- **`CatTheme+Badge.swift`**: Fill in the correct token for each visual property per variant (the scaffold uses `Primary` defaults — adjust for each variant)
- **`CatBadgeBuilder.swift`**: Implement `buildContent()` — the scaffold creates the structure but you fill in the layout
- **`Badge.kt`**: Resolve `TODO` markers

**Step 7: Move files to source**

```
output/badge/CatBadgeStyle.swift    → iOS/Catalyst/Sources/Catalyst/Components/Badges/
output/badge/CatBadgeBuilder.swift  → iOS/Catalyst/Sources/Catalyst/Components/Badges/
output/badge/CatTheme+Badge.swift   → iOS/Catalyst/Sources/Catalyst/Theme/
output/badge/Badge.kt               → android/catalyst/src/main/java/com/haiilo/catalyst/components/
```

**Step 8: Open in Xcode and build**

SwiftLint runs on CI but also locally if you have it installed:
```bash
cd iOS && swiftlint lint Catalyst/Sources/Catalyst/Components/Badges/
```

Build the demo app and verify the component visually.

---

### Workflow B — "I want the LLM to draft the spec"

Use this when starting from scratch with no Figma spec.

```bash
cd scripts/agents

# Full pipeline — LLM drafts spec, audits tokens, scaffolds, reviews
node orchestrator.js --component=badge \
  --context="A small indicator that shows a count or status dot. Used on avatars and nav items."
```

Then **critically review `output/badge/spec.md`** — the LLM won't know your specific Figma decisions. Edit it to match the actual design before proceeding with the scaffold.

After editing spec.md, re-run audit and scaffold:
```bash
node orchestrator.js --component=badge --skip-research
```

---

## Spec Format

The canonical format is a JSON contract inside `spec.md`:

````markdown
## Spec Contract (Machine Readable)

```json
{
  "specVersion": 1,
  "component": "badge",
  "interactivity": "non-interactive",
  "states": ["normal", "focused", "disabled"],
  "sizes": [
    {
      "name": "small",
      "heightToken": "size.lg",
      "horizontalPaddingToken": "spacing.xs",
      "verticalPaddingToken": "spacing.xxs",
      "fontToken": "typography.s2"
    }
  ],
  "defaultSize": "small",
  "contentCases": ["text(String)", "count(Int)", "dot"],
  "sharedTokens": {
    "cornerRadius": "border-radius.full",
    "borderWidth": "none"
  },
  "variants": [
    {
      "name": "primary",
      "stateTokens": {
        "normal": {
          "background": "color.theme.primary.bg",
          "foreground": "color.theme.primary.fill",
          "border": "none",
          "focusRing": "color.ui.border.focus"
        }
      }
    }
  ],
  "missingTokens": ["component.badge.size.dot"]
}
```
````

Rules:
- Put **unknown/unavailable tokens** in `missingTokens`, not in token fields.
- Use sentinel values (`none`, `-`, `n/a`) only for intentionally absent visual values.
- Run `spec-validate-agent` before audit/scaffold.

---

## Editing Generated Files

### `Cat{Name}Style.swift` — What to look at

1. **`Cat{Name}StateProperties`** — Remove any fields that don't apply to this component. A non-interactive Badge probably doesn't need `isUnderlined` or `scale`. Keep it lean.

2. **`resolveState()`** — If the component has no pressed/hover state (e.g. a static Badge), simplify to:
   ```swift
   private func resolveState() -> CatBadgeStateStyle {
       guard isEnabled else { return styleConfig.disabled }
       return styleConfig.normal
   }
   ```

3. **Size enum** — Check that each case maps to the right `CatSizes` token. The scaffold makes a best guess — verify against the Figma spec.

### `CatTheme+{Name}.swift` — What to look at

This is where your token decisions live. The scaffold generates a `defaultConfig` using `Primary` colors. For each visual property in each state, verify it uses the correct token:

```swift
// Before (scaffold default)
normal: .init(
    colorStyle: CatBadgeStateColorStyle(
        background: CatColors.Theme.Primary.bg,
        foreground: CatColors.Theme.Primary.fill,
        border: Color.clear
    )
),

// After (adjusted for a danger/error badge variant)
normal: .init(
    colorStyle: CatBadgeStateColorStyle(
        background: CatColors.Theme.Danger.bg,
        foreground: CatColors.Theme.Danger.fill,
        border: Color.clear
    )
),
```

To add a new variant (e.g. `success`):
```swift
public static let successConfig = CatBadgeStateStyleConfig(
    normal: .init(colorStyle: CatBadgeStateColorStyle(
        background: CatColors.Theme.Success.bg,
        foreground: CatColors.Theme.Success.fill,
        border: Color.clear
    )),
    focused: ...,
    disabled: ...
)
```

### `Cat{Name}Builder.swift` — What to look at

The `buildContent()` function is intentionally left as a `// TODO`. Fill it in following the same `switch content` pattern as `CatButtonBuilder`:

```swift
@ViewBuilder
private func buildContent() -> some View {
    switch content {
    case .dot:
        Circle()
            .frame(width: CatSizes.sizeSm, height: CatSizes.sizeSm)
    case .count(let number):
        Text("\(number)")
            .font(CatTypography.caption)
    }
}
```

### `{Name}.kt` — What to look at

Android skeletons have `// TODO:` markers for:
- **Content model**: Replace the `label: String` with your actual content model once it's agreed
- **Border wiring**: The Compose border API needs alignment — check `CatBorderWidth` token usage
- **Interaction states**: Compose `InteractionSource` for hover/press once Android matures

---

## Troubleshooting

**`Error: GITHUB_TOKEN not set`**
- Check that `.env` exists in `scripts/agents/` (not the repo root)
- Check that `GITHUB_TOKEN` is set and starts with `github_pat_`
- Verify the token has **Models: Read-only** permission — other scopes are not enough
- If the token expired, generate a new one at https://github.com/settings/personal-access-tokens

**`Error: Template not found`**
- Make sure you're running from the `scripts/agents/` directory, or use `npm run scaffold -- --component=badge`

**`No token paths found in spec.md`**
- The audit agent looks for backtick-wrapped paths like `` `color.theme.primary.bg` `` or tables with a "token" column header
- Add at least a few inline references to your spec

**`Handlebars template error: ... is not defined`**
- Usually means a `--has-content-enum` or `--sizes` flag is needed for this component
- Re-run scaffold with the appropriate flags

**Generated Swift file has `TODO: map X to correct CatSizes token`**
- The scaffold couldn't find a matching size for the name you gave (e.g. `xl`, `xs`)
- Open `iOS/Catalyst/Sources/Catalyst/Tokens/Generated/CatSizes.swift` and pick the right constant
- Replace the TODO comment with the correct token

---

## File Structure

```
scripts/agents/
  package.json                # Node dependencies
  .env.example                # API key template — copy to .env
  .env                        # Your keys — gitignored

  orchestrator.js             # Chains all agents
  spec-template-agent.js      # Creates canonical spec.md contract
  spec-validate-agent.js      # Validates contract fields before audit/scaffold
  spec-contract.js            # Shared parser/helpers for contract-based agents
  research-agent.js           # LLM: generates spec.md (optional)
  token-audit-agent.js        # Reads tokens/src/ → token-audit.md (offline)
  scaffold-agent.js           # Template engine → Swift + Kotlin files (offline)
  review-agent.js             # LLM: reviews generated files → review.md

  templates/
    CatComponentStyle.swift.hbs    # State machine types + ViewModifier
    CatComponentBuilder.swift.hbs  # Layout helper + public view
    CatTheme+Component.swift.hbs   # CatTheme extension with configs
    Component.kt.hbs               # Android Compose skeleton

  output/                     # Gitignored — staging area for generated files
    {component}/
      spec.md
      spec-validation.md
      token-audit.md
      Cat{Name}Style.swift
      Cat{Name}Builder.swift
      CatTheme+{Name}.swift
      {Name}.kt
      review.md
      manifest.json
```

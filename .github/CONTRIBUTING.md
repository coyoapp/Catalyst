# Contributing to the Catalyst

First off, thank you for helping us build a better UI experience! To keep our library high-quality, please follow these guidelines.

---

## 1. How to Report a Bug
* Check if the issue already exists in the "Issues" tab.
* Use our **Bug Report** template.
* **Crucial:** Include screenshots or screen recordings of the UI glitch on both iOS and Android if possible.

## 2. How to Propose a Feature
* Open an issue using the **Feature Request** template.
* Explain the "Why"—what design problem are we solving?

## 3. Development Workflow
1. Fork the repository.
2. Create a branch: `feat/component-name` or `fix/issue-description`.
3. **Commit Messages:** We use [Conventional Commits](https://www.conventionalcommits.org/).
   - Format: `type(scope): description`
   - Examples: `feat(button): add loading state`, `fix(colors): update primary-500 hex`
   - *Note: This is required for our automated CHANGELOG.*

### 3.1. Working with Design Tokens

> ⚠️ Token generation is an automated process. Do not manually edit any generated files under the iOS or Android projects.
>
> Generation is triggered from the `tokens` project using:
> * `npm run build:build` — Builds everything (tokens + icons)
> * `npm run build:tokens` — Builds only tokens
> * `npm run build:icons` — Builds only icons

1. The design team provides updated token JSON files or icons via Figma. Avoid manual changes and ensure naming conventions are consistent to prevent conflicts.
2. Fork the repository.
3. Create a branch: `feat/token-` or `fix/token-`.
4. Place the received icons or token files under `tokens/src`. Do not change the format or folder structure of existing files.
5. **Commit Messages:** We use [Conventional Commits](https://www.conventionalcommits.org/).
   - Format: `type(scope): description`
   - Examples: `feat(icons): add new icons`, `fix(icons): update icon-checkmark`
   - *Note: This is required for our automated CHANGELOG.*

## 4. UI & Visual Testing
Before submitting a PR, ensure:
* The component looks correct in **Demo Applications**.
* You have tested on a small screen (e.g., iPhone SE) and a large tablet.

## 5. Review Process
* All PRs require approval from the **@coyoapp/mobile-design-core** team.
* Your branch must be up-to-date with `main` before merging.
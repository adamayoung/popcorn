# Reference Index

Quick navigation for SwiftUI accessibility topics.

## Descriptions & Labels

| File | Description |
|------|-------------|
| `accessible-descriptions.md` | Labels, values, hints, headings, custom content, input labels, speech customization |

## Controls & Interaction

| File | Description |
|------|-------------|
| `accessible-controls.md` | Traits (all 17), actions, adjustable controls, gestures, scroll, drag/drop, representation |

## Appearance & Adaptability

| File | Description |
|------|-------------|
| `accessible-appearance.md` | Dynamic Type, color/contrast, motion preferences, transparency, AT environment checks |

## Navigation & Focus

| File | Description |
|------|-------------|
| `accessible-navigation.md` | Sort priority, rotors, linked groups, focus management, notifications, chart accessibility |

## Grouping & Hierarchy

| File | Description |
|------|-------------|
| `accessible-grouping.md` | Children behavior (combine/contain/ignore), conditional grouping, hidden, modal, Canvas |

## Testing & Verification

| File | Description |
|------|-------------|
| `accessible-testing.md` | Accessibility Inspector, VoiceOver checklist, Voice Control, automated audits, visionOS |

---

## Quick Links by Problem

### I need to...

- **Add a label to an icon button** → `accessible-descriptions.md` (Accessibility Labels)
- **Add a hint to a navigation button** → `accessible-descriptions.md` (When to Add Hints)
- **Hide a decorative image from VoiceOver** → `accessible-descriptions.md` (Decorative Images)
- **Group a card into one VoiceOver stop** → `accessible-grouping.md` (Accessibility Children Behavior)
- **Make a custom control work with VoiceOver** → `accessible-controls.md` (Accessibility Traits, Actions)
- **Make carousel items individually selectable** → `accessible-controls.md` (Per-Item Buttons)
- **Make a carousel swipe-adjustable** → `accessible-controls.md` (Adjustable Single Element)
- **Support Dynamic Type properly** → `accessible-appearance.md` (Dynamic Type)
- **Check if reduce motion is on** → `accessible-appearance.md` (Motion Preferences)
- **Move VoiceOver focus after a change** → `accessible-navigation.md` (Focus Management)
- **Create a custom VoiceOver rotor** → `accessible-navigation.md` (Rotors)
- **Run automated accessibility tests** → `accessible-testing.md` (performAccessibilityAudit)
- **Test with VoiceOver systematically** → `accessible-testing.md` (VoiceOver Testing Checklist)
- **Add extra info without cluttering VoiceOver** → `accessible-descriptions.md` (Custom Content)

### I'm getting a VoiceOver issue with...

- **"Button" announced with no label** → `accessible-descriptions.md` (Accessibility Labels)
- **Button says item name but not what it does** → `accessible-descriptions.md` (When to Add Hints)
- **Carousel items not individually selectable** → `accessible-controls.md` (Per-Item Buttons) — don't use `.accessibilityElement()` on container
- **Decorative image being read aloud** → `accessible-descriptions.md` (Decorative Images)
- **Too many VoiceOver stops on a card** → `accessible-grouping.md` (.combine)
- **Color-only status not conveyed** → `accessible-appearance.md` (Differentiate Without Color)
- **Custom control not interactive** → `accessible-controls.md` (Traits, Actions)
- **Elements read in wrong order** → `accessible-navigation.md` (Sort Priority)
- **Animation ignoring user preferences** → `accessible-appearance.md` (Reduce Motion)
- **Focus not moving after content change** → `accessible-navigation.md` (Focus Management, Notifications)
- **Modal not trapping focus** → `accessible-grouping.md` (Modal Views)
- **Canvas with no accessibility** → `accessible-grouping.md` (Synthetic Children)

---

## File Statistics

| File | ~Lines | Primary Topics |
|------|--------|---------------|
| `accessible-descriptions.md` | 260 | Labels, values, hints, headings, custom content, speech |
| `accessible-controls.md` | 280 | Traits, actions, adjustable, gestures, representation |
| `accessible-appearance.md` | 270 | Dynamic Type, color, contrast, motion, transparency |
| `accessible-navigation.md` | 270 | Sort priority, rotors, focus, notifications, charts |
| `accessible-grouping.md` | 260 | Children behavior, conditional, hidden, modal, Canvas |
| `accessible-testing.md` | 260 | Inspector, VoiceOver checklist, audits, visionOS |

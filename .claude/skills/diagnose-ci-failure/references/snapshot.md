# Snapshot-test failure (Build and Snapshot Test)

The **Build and Snapshot Test** job (workflow "Snapshot Tests", job
`snapshot-tests`) builds and runs the `PopcornSnapshotTests` test plan:

```bash
xcodebuild -scheme Popcorn \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5" \
  -skipMacroValidation -testPlan PopcornSnapshotTests \
  CODE_SIGNING_ALLOWED=NO test-without-building
```

Tests use **swift-snapshot-testing**: each test renders a SwiftUI view and
compares it to a committed reference image. A mismatch fails the test and the job
uploads `SnapshotTestResults.xcresult.zip`.

> CI renders on a **fixed simulator** (iPhone 17 Pro, iOS 26.5). Reference images
> must be recorded on the matching device/OS, or unrelated device/OS drift
> produces false diffs. Record locally on the same simulator.

## Reading the failure

- The failure message reads like *"Snapshot does not match reference"* and points
  at the test `file:line`. The attached `.xcresult` carries the **reference**,
  **failure**, and **difference** images — inspect them to see *what* changed.
- Reference images live next to each test in
  `Features/<Feature>/Tests/<Feature>SnapshotTests/__Snapshots__/`.

## Decide: legitimate change vs regression

This is the key judgement — don't blindly re-record:

1. **The view legitimately changed** (you intended the visual difference: new
   copy, layout, colour, component). Then the reference is stale → **re-record**
   the reference image and commit the updated PNG.
2. **Unintended visual regression** (the diff is a side effect you didn't mean —
   a broken layout, missing element, wrong state). Then the reference is correct
   → **fix the view/view model** so it renders the expected output again.

If unsure, open the difference image: a small, explainable delta that matches
your change is case 1; anything surprising is case 2.

## Re-record workflow (case 1 only)

1. Set the relevant test(s) to record mode (`withSnapshotTesting(record: .all)`
   around the test, or the per-assertion `record:` parameter) — see the
   `snapshot-testing-expert` skill for the exact API.
2. Run `/test-snapshots` on the **same simulator** CI uses; the run rewrites the
   PNGs under `__Snapshots__/` and "fails" once while recording.
3. Remove record mode, run `/test-snapshots` again to confirm it now passes, and
   commit the regenerated reference images.

## Reproduce locally

- `/test-snapshots` — builds and runs the `PopcornSnapshotTests` plan (Haiku
  subagent). Use the iPhone 17 Pro / iOS 26.5 simulator to match CI.

## Output

**Summary:** Build and Snapshot Test — `Suite/test` snapshot mismatch at `file:line`.
**Cause:** intended view change (stale reference) **or** unintended visual regression — say which, from the diff image.
**Fix:** re-record + commit the reference PNG (case 1) **or** fix the view (case 2); re-run `/test-snapshots`.

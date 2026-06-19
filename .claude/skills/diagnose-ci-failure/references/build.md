# Build failure (Build and Test — Build step)

The **Build and Test** job (workflow "Unit Tests", job `unit-tests`) first runs
the **Build** step:

```bash
xcodebuild -scheme Popcorn \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5" \
  -skipMacroValidation -testPlan PopcornUnitTests \
  CODE_SIGNING_ALLOWED=NO build-for-testing
```

It compiles the app and **all unit-test targets**. The project builds under
**Swift 6.2 strict concurrency**, and the build pipeline treats **warnings as
errors** — code that compiles "cleanly" in a relaxed local build can still fail
CI on a single warning. Reproduce with `/build-for-testing`, which builds with
the same warnings-as-errors flags, not a plain `swift build`.

## Reading the failure

- `file:line: error: <message>` — a genuine compile error.
- `file:line: warning: <message>` promoted to an error. Common Swift 6.2 ones:
  - **`Sendable` / actor-isolation / `@MainActor`** — a value crossing isolation
    boundaries isn't `Sendable`, or a call hops an actor without `await`.
  - **Deprecation** — using an API the project or a newer SDK deprecated.
  - **Unused** — unused variable, unused result, unreachable code.
  - **Missing/incorrect availability** annotations (iOS 26 / macOS 26 / visionOS).

## Common causes & fixes

1. **Compile error in changed code** — fix the type/signature/import at the
   reported `file:line`.
2. **Warning under warnings-as-errors** — resolve it properly rather than
   silencing: add the missing `Sendable` conformance / `@MainActor`, mark the
   crossing value `nonisolated`/`sending` as appropriate, replace the deprecated
   call, remove the unused binding. The `swift-concurrency` skill helps with the
   isolation cases.
3. **Build failed because a *public interface* changed in a context/adapter** —
   a package's `public` API changed but a downstream feature/composition-root
   call site wasn't updated. Fix the call site; this is why interface changes
   need a full-app build, not a package-only one.

## Reproduce locally

- `/build-for-testing` — builds the app + all test targets with
  warnings-as-errors (Haiku subagent; closest match to the failing CI step).

## Output

**Summary:** Build and Test — Build step — `error`/`warning` at `file:line`.
**Cause:** the compile error or warnings-as-errors warning, tied to a changed file.
**Fix:** resolve it at `file:line`; reproduce with `/build-for-testing`.

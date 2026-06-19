# Release-build failure (Build (Release))

The **Build (Release)** job (workflow "Release Build", job `release-build`)
compiles the app in the **Release** configuration:

```bash
xcodebuild -scheme Popcorn -configuration Release \
  -destination "generic/platform=iOS" -skipMacroValidation \
  CODE_SIGNING_ALLOWED=NO build
```

This exists to catch failures the Debug `build-for-testing` jobs **miss**. In
Release, `#if DEBUG` code is excluded and the optimiser runs, mirroring the
Xcode Cloud archive build. So a job that builds fine in Debug can fail only here.

## Reading the failure

- `file:line: error: <message>` from `swiftc` during the Release compile. The
  giveaway is that the **same file builds in the Unit Tests / Snapshot jobs** but
  fails here — that points at a Debug-vs-Release difference.

## Common causes & fixes

1. **A `#if DEBUG`-gated symbol referenced from a non-DEBUG path.** A type,
   property, or function defined inside `#if DEBUG` is used by code that compiles
   in Release. In Release the symbol doesn't exist → "cannot find … in scope".
   Fix: move the symbol out of the `#if DEBUG`, or gate the **use site** in
   `#if DEBUG` too.

2. **A `#Preview` referencing DEBUG-only code.** `#Preview` macros expand into
   compiled code in Release unless themselves gated. If a preview references a
   DEBUG-only mock/factory, Release can't find it. Fix: wrap the whole `#Preview`
   in `#if DEBUG`, or make the referenced helper available in Release.

3. **Optimisation-sensitive issue.** Rarer — code that only type-checks/compiles
   under the Debug build settings. Resolve the underlying compile error at
   `file:line`; the fix is the same Swift fix, just exercised by the Release
   config.

## Reproduce locally

Run a Release build with the same configuration (delegate the `xcodebuild` to a
Haiku subagent so the log stays out of context):

```bash
xcodebuild -scheme Popcorn -configuration Release \
  -destination "generic/platform=iOS" -skipMacroValidation \
  CODE_SIGNING_ALLOWED=NO build
```

(Or trigger an Archive/Release build in Xcode.) A normal `/build-for-testing`
runs Debug and will **not** reproduce this.

## Output

**Summary:** Build (Release) — `error` at `file:line` (Debug-only symbol in a Release path).
**Cause:** the `#if DEBUG` / `#Preview` reference (or optimisation issue), tied to a changed file.
**Fix:** move/gate the symbol or its use site; reproduce with a local `-configuration Release` build.

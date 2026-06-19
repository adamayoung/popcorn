# CI failure diagnosis — reference index

Popcorn has **four blocking CI jobs**. Each has its own failure signature and
reference file. Identify the failing job (`gh pr checks`, or
`gh run view <id> --log-failed`), then open the matching file.

> `claude-review` is a **non-blocking neutral** PR check, not a CI job — ignore
> it here.

| Failing job (`name:` in the workflow) | Reference | When to use |
|---|---|---|
| **Lint** | [lint.md](lint.md) | `swiftlint --strict .` or `swiftformat --lint .` failed |
| **Build and Test** (Build step) | [build.md](build.md) | `xcodebuild … build-for-testing` failed (compile error/warning) |
| **Build and Test** (Unit Test step) | [unit-tests.md](unit-tests.md) | `xcodebuild … test` on the `PopcornUnitTests` plan failed |
| **Build and Snapshot Test** | [snapshot.md](snapshot.md) | `PopcornSnapshotTests` plan failed (image mismatch) |
| **Build (Release)** | [release-build.md](release-build.md) | `xcodebuild -configuration Release … build` failed |

## By symptom

- SwiftLint `(rule_id)` violation → [lint.md](lint.md)
- `superfluous_disable_command` on **unchanged** code → [lint.md](lint.md) (version drift)
- SwiftFormat `--lint` reports a file would change → [lint.md](lint.md)
- `warning: … treated as error` / `swiftc` `error:` on the Build step → [build.md](build.md)
- `Sendable` / actor-isolation / `@MainActor` / deprecation warning → [build.md](build.md)
- `#expect`/`#require` failure, recorded `Suite/test` → [unit-tests.md](unit-tests.md)
- A view-model test asserting on `.ready`/`.error` `viewState` → [unit-tests.md](unit-tests.md)
- A test target "doesn't run" / missing from `PopcornUnitTests.xctestplan` → [unit-tests.md](unit-tests.md)
- SwiftData crash decoding the on-disk store (`NSNumber`→`NSString`) → [unit-tests.md](unit-tests.md)
- A snapshot test fails with a reference-image diff → [snapshot.md](snapshot.md)
- Compiles in Debug but fails only in `Build (Release)` → [release-build.md](release-build.md)

All paths share the [output format](../SKILL.md#output-format): **Summary / Cause / Fix**.

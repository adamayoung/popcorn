---
name: test-snapshots
description: Run snapshot tests
---

# Run snapshot tests

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make test-snapshots` from the project root and report back pass/fail with any test failures.

This builds and runs the `PopcornSnapshotTests` test plan on the iOS Simulator.

## Running a subset of tests

To run all tests in a specific test class:

```bash
make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewTests
```

To run a single test method:

```bash
make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewTests/testSnapshot
```

## Arguments

The skill accepts an optional argument for the test class or test method:

- No argument: runs all snapshot tests
- `<TestTarget>/<TestClass>`: runs all tests in that class
- `<TestTarget>/<TestClass>/<testMethod>`: runs a single test

If tests fail, review the output for failure details. Snapshot failures typically mean the rendered UI has changed — inspect the failure images to determine if the change is intentional.

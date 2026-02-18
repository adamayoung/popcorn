---
name: test-ui
description: Run UI tests
---

# Run UI tests

Run `make test-ui` from the project root.

This builds and runs the `PopcornUITests` test plan on the iOS Simulator.

## Running a subset of tests

To run all tests in a specific test class:

```bash
make test-ui TEST_CLASS=PopcornUITests/ExploreTests
```

To run a single test method:

```bash
make test-ui TEST_CLASS=PopcornUITests/ExploreTests/testLaunch
```

## Arguments

The skill accepts an optional argument for the test class or test method:

- No argument: runs all UI tests
- `<TestTarget>/<TestClass>`: runs all tests in that class
- `<TestTarget>/<TestClass>/<testMethod>`: runs a single test

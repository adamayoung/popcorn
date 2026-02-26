---
name: build-package-for-testing
description: Build an individual Swift package for testing
---

# Build a Swift package for testing

Build a single Swift package including its test targets. Use this when you only need to verify a specific package's tests compile — use `/build-for-testing` instead when you need to build the entire app for testing.

## Command

Run from the package directory:

```
cd <package-dir> && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1
```

### Examples

```bash
# Context package
cd Contexts/PopcornMovies && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1

# Adapter package
cd Adapters/Contexts/PopcornMoviesAdapters && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1

# Feature package
cd Features/MovieDetailsFeature && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1
```

### Package locations

| Layer | Path pattern |
|-------|-------------|
| Contexts | `Contexts/<PackageName>/` |
| Context Adapters | `Adapters/Contexts/<PackageName>/` |
| Platform Adapters | `Adapters/Platform/<PackageName>/` |
| Features | `Features/<PackageName>/` |
| Core | `Core/<PackageName>/` |
| Platform | `Platform/<PackageName>/` |
| AppDependencies | `AppDependencies/` |

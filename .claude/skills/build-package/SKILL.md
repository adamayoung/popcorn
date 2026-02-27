---
name: build-package
description: Build an individual Swift package
---

# Build a Swift package

Build a single Swift package. Use this when you only need to verify a specific package compiles — use `/build` instead when you need to build the entire app.

## Command

Run from the package directory:

```
cd <package-dir> && swift build -Xswiftc -warnings-as-errors 2>&1
```

### Examples

```bash
# Context package
cd Contexts/PopcornMovies && swift build -Xswiftc -warnings-as-errors 2>&1

# Adapter package
cd Adapters/Contexts/PopcornMoviesAdapters && swift build -Xswiftc -warnings-as-errors 2>&1

# Feature package
cd Features/MovieDetailsFeature && swift build -Xswiftc -warnings-as-errors 2>&1

# Core package
cd Core/CoreDomain && swift build -Xswiftc -warnings-as-errors 2>&1

# Platform package
cd Platform/Caching && swift build -Xswiftc -warnings-as-errors 2>&1
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

---
name: build-package
description: Build an individual Swift package
---

# Build a Swift package

Build a single Swift package. Use this when you only need to verify a specific package compiles — use `/build` instead when you need to build the entire app.

## Command

Run from the package directory:

```
cd <package-dir> && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror
```

### Examples

```bash
# Context package
cd Contexts/PopcornMovies && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

# Adapter package
cd Adapters/Contexts/PopcornMoviesAdapters && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

# Feature package
cd Features/MovieDetailsFeature && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

# Core package
cd Core/CoreDomain && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

# Platform package
cd Platform/Caching && set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror
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

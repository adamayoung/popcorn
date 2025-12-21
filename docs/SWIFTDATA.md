# Agent guide for SwiftData

## SwiftData instructions

If SwiftData is configured to use CloudKit:

- Never use `@Attribute(.unique)`.
- Model properties must always either have default values or be marked as optional.
- All relationships must be marked optional.

## Where to use

SwiftData is used in the Infrastructure layer:

- `@Model` classes define persistence schema
- Repository implementations use `ModelContext`
- Never expose `@Model` types outside Infrastructure layer
- Map to Domain entities at repository boundary

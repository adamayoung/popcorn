# Agent guide for using Clean Architecture

Context modules should follow Clean Architecture best practices.

## Directory Structure

e.g.

Popcorn/
├── Contexts/                                                   # Bounded contexts (DDD layers)
│   ├── PopcornMovies/                                          # Context-specific domain
│      ├── Sources                                              # Swift package Sources directory
│         ├── MoviesComposition                                 # Composition layer which wires up all the modules
│         ├── MoviesApplication                                 # Application layer
│            ├── UseCases                                       # Application use case
│               └── FetchMovieDetails                           # Fetch movie details use case
│                  ├── FetchMoviesUseCase.swift                 # Fetch movie details use case protocol
│                  ├── DefaultFetchMovieDetailsUseCase.swift    # Fetch movie details use case implementation
│                  └── FetchMovieDetailsError.swift             # Fetch movie details use case error
│            ├── Models                                         # Application models
│            └── Mappers                                        # Domain model to application model mappers
│         ├── MoviesDomain                                      # Domain layer
│            ├── Entities                                       # Domain entities
│            ├── Repositories                                   # Repository protocols
│            ├── DataSources                                    # Data source protocols
│            └── Providers                                      # Provider protocols (when access data from other contexts)
│         └── MoviesInfrastructure                              # Infrastructure layer
│            ├── Repositories                                   # Repository implementations
│            └── DataSources                                    # Data source implementations
│               ├── Local                                       # Local data source implementations
│               └── Remote                                      # Remote data source implementations

## Layer Dependencies

Domain ← Application ← Infrastructure
    ↑                      ↓
    └──── Composition ─────┘

Rules:

- Domain has NO dependencies (pure business logic)
- Application depends on Domain (uses entities, repositories)
- Infrastructure depends on Domain (implements repositories)
- Composition wires everything together

## Data Flow Example

View → TCA Reducer → Use Case → Repository → Data Source
                        ↓            ↓             ↓
                    App Model ← Domain Model ← DTO

## Cross-Context Communication

Contexts communicate through Providers:

- Provider protocols defined in consuming Domain layer
- Provider implementations in Infrastructure layer
- Example: MoviesProvider, UserProvider

## Mapper Pattern

Map at boundaries:

- DTO → Domain Entity (in Repository)
- Domain Entity → Application Model (in Use Case)
- Never expose Infrastructure types to Application

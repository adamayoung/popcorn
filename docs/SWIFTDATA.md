# Agent guide for SwiftData

## CloudKit Constraints

When SwiftData is configured with CloudKit sync:

- Never use `@Attribute(.unique)` - causes sync conflicts
- Model properties must have default values or be optional
- All relationships must be optional

## Infrastructure Layer Usage

SwiftData is used exclusively in the Infrastructure layer:

- `@Model` classes define persistence schema
- Repository implementations use `ModelContext`
- Never expose `@Model` types outside Infrastructure
- Map to Domain entities at repository boundary

## Model Definition

```swift
// Infrastructure/DataSources/Local/Models/MoviesMovieEntity.swift
@Model
final class MoviesMovieEntity {
    // Primary identifier (NOT @Attribute(.unique) for CloudKit)
    var movieID: Int = 0

    // All properties have defaults or are optional
    var title: String = ""
    var overview: String = ""
    var releaseDate: Date?
    var posterPath: String?
    var backdropPath: String?

    // Cache management
    var lastUpdated: Date = Date.now

    // Relationships must be optional
    var imageCollection: MoviesImageCollectionEntity?

    init(movieID: Int, title: String, overview: String) {
        self.movieID = movieID
        self.title = title
        self.overview = overview
    }
}
```

## Mapping to Domain Entities

```swift
// Infrastructure/DataSources/Local/Mappers/MovieMapper.swift
struct MovieMapper {
    func map(_ entity: MoviesMovieEntity) -> Movie {
        Movie(
            id: entity.movieID,
            title: entity.title,
            overview: entity.overview,
            releaseDate: entity.releaseDate,
            posterPath: entity.posterPath.flatMap { URL(string: $0) },
            backdropPath: entity.backdropPath.flatMap { URL(string: $0) }
        )
    }

    func map(_ movie: Movie) -> MoviesMovieEntity {
        let entity = MoviesMovieEntity(
            movieID: movie.id,
            title: movie.title,
            overview: movie.overview
        )
        entity.releaseDate = movie.releaseDate
        entity.posterPath = movie.posterPath?.absoluteString
        entity.backdropPath = movie.backdropPath?.absoluteString
        entity.lastUpdated = .now
        return entity
    }
}
```

## Local Data Source Pattern

```swift
// Infrastructure/DataSources/Local/SwiftDataMovieLocalDataSource.swift
@ModelActor
actor SwiftDataMovieLocalDataSource: MovieLocalDataSource {
    private let ttl: TimeInterval = 60 * 60 * 24  // 1 day cache

    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie? {
        let descriptor = FetchDescriptor<MoviesMovieEntity>(
            predicate: #Predicate { $0.movieID == id }
        )

        guard let entity = try modelContext.fetch(descriptor).first else {
            return nil
        }

        // Check TTL - return nil if expired
        guard !isExpired(entity.lastUpdated, ttl: ttl) else {
            return nil
        }

        return MovieMapper().map(entity)
    }

    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError) {
        let entity = MovieMapper().map(movie)
        modelContext.insert(entity)
        try modelContext.save()
    }

    private func isExpired(_ date: Date, ttl: TimeInterval) -> Bool {
        Date.now.timeIntervalSince(date) > ttl
    }
}
```

## Repository Using Local + Remote

```swift
// Infrastructure/Repositories/DefaultMovieRepository.swift
final class DefaultMovieRepository: MovieRepository {
    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieLocalDataSource

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        // Try cache first
        if let cached = try await localDataSource.movie(withID: id) {
            return cached
        }

        // Fetch from remote
        let movie = try await remoteDataSource.movie(withID: id)

        // Update cache
        try await localDataSource.setMovie(movie)

        return movie
    }
}
```

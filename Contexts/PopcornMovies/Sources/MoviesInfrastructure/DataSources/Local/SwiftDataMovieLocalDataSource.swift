//
//  SwiftDataMovieLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataMovieLocalDataSource: MovieLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie? {
        let entity: MoviesMovieEntity?
        var descriptor = FetchDescriptor<MoviesMovieEntity>(
            predicate: #Predicate { $0.movieID == id })
        descriptor.fetchLimit = 1
        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .unknown(error)
        }

        guard let entity else {
            Self.logger.trace("SwiftData MISS: Movie(id: \(id, privacy: .public))")
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.trace("SwiftData EXPIRED: Movie(id: \(id, privacy: .public)) — deleting")
            modelContext.delete(entity)
            do { try modelContext.save() } catch let error { throw .unknown(error) }
            return nil
        }

        Self.logger.trace("SwiftData HIT: Movie(id: \(id, privacy: .public))")

        let mapper = MovieMapper()
        return mapper.map(entity)
    }

    func movieStream(forMovie id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        let descriptor = FetchDescriptor<MoviesMovieEntity>(
            predicate: #Predicate { $0.movieID == id })
        let stream = stream(for: descriptor) {
            MovieMapper().compactMap($0.first)
        }

        return stream
    }

    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError) {
        let id = movie.id
        let descriptor = FetchDescriptor<MoviesMovieEntity>(
            predicate: #Predicate { $0.movieID == id })
        let existing: MoviesMovieEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .unknown(error)
        }

        let mapper = MovieMapper()
        if let existing {
            mapper.map(movie, to: existing)
            existing.cachedAt = .now
        } else {
            let entity = mapper.map(movie)
            modelContext.insert(entity)
        }

        do { try modelContext.save() } catch let error { throw .unknown(error) }
    }

    func certification(forMovie movieID: Int) async throws(MovieLocalDataSourceError) -> String? {
        let entity: MoviesMovieCertificationEntity?
        var descriptor = FetchDescriptor<MoviesMovieCertificationEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.debug("SwiftData MISS: MovieCertification(movie-id: \(movieID, privacy: .public))")
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: MovieCertification(movie-id: \(movieID, privacy: .public)) - deleting"
            )
            modelContext.delete(entity)
            do {
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }
            return nil
        }

        Self.logger.debug("SwiftData HIT: MovieCertification(movie-id: \(movieID, privacy: .public))")

        return entity.certification
    }

    func setCertification(_ certification: String, forMovie movieID: Int) async throws(MovieLocalDataSourceError) {
        let descriptor = FetchDescriptor<MoviesMovieCertificationEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        let existing: MoviesMovieCertificationEntity?

        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        if let existing {
            existing.certification = certification
            existing.cachedAt = Date.now
        } else {
            let entity = MoviesMovieCertificationEntity(movieID: movieID, certification: certification)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}

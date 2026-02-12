//
//  SwiftDataMovieImageLocalDataSource.swift
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
actor SwiftDataMovieImageLocalDataSource: MovieImageLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageLocalDataSourceError) -> ImageCollection? {
        let entity: MoviesImageCollectionEntity?
        var descriptor = FetchDescriptor<MoviesImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .unknown(error)
        }

        guard let entity else {
            Self.logger.debug(
                "SwiftData MISS: ImageCollection(movie-id: \(movieID, privacy: .public))"
            )
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: ImageCollection(movie-id: \(movieID, privacy: .public)) — deleting"
            )
            modelContext.delete(entity)
            do { try modelContext.save() } catch let error { throw .unknown(error) }
            return nil
        }

        Self.logger.debug("SwiftData HIT: ImageCollection(movie-id: \(movieID, privacy: .public))")

        let mapper = ImageCollectionMapper()
        return mapper.map(entity)
    }

    func imageCollectionStream(forMovie movieID: Int) -> AsyncThrowingStream<
        ImageCollection?, Error
    > {
        let descriptor = FetchDescriptor<MoviesImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        return stream(for: descriptor) {
            ImageCollectionMapper().compactMap($0.first)
        }
    }

    func setImageCollection(
        _ imageCollection: ImageCollection
    ) async throws(MovieImageLocalDataSourceError) {
        let movieID = imageCollection.id
        let descriptor = FetchDescriptor<MoviesImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        let mapper = ImageCollectionMapper()
        let existing: MoviesImageCollectionEntity?
        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .unknown(error)
        }

        if let existing {
            mapper.map(imageCollection, to: existing)
        } else {
            let entity = mapper.map(imageCollection)
            modelContext.insert(entity)
        }

        do { try modelContext.save() } catch let error { throw .unknown(error) }
    }

}

//
//  SwiftDataMovieImageLocalDataSource.swift
//  PopcornMovies
//
//  Created by Adam Young on 03/12/2025.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataMovieImageLocalDataSource: MovieImageLocalDataSource, SwiftDataFetchStreaming,
    Sendable
{

    private static let logger = Logger(
        subsystem: "PopcornMovies",
        category: "SwiftDataMovieImageLocalDataSource"
    )

    private var ttl: TimeInterval = 60 * 60 * 24  // 1 day

    func imageCollection(
        forMovie movieID: Int
    ) async throws(MovieImageLocalDataSourceError) -> ImageCollection? {
        let entity: ImageCollectionEntity?
        var descriptor = FetchDescriptor<ImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .unknown(error)
        }

        guard let entity else {
            //            Self.logger.trace("SwiftData MISS: ImageCollection(movie-id: \(movieID, privacy: .public))")
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            //            Self.logger.trace("SwiftData EXPIRED: ImageCollection(movie-id: \(movieID, privacy: .public)) — deleting")
            modelContext.delete(entity)
            do { try modelContext.save() } catch let error { throw .unknown(error) }
            return nil
        }

        //        Self.logger.trace("SwiftData HIT: ImageCollection(movie-id: \(movieID, privacy: .public))")

        let mapper = ImageCollectionMapper()
        return mapper.map(entity)
    }

    func imageCollectionStream(forMovie movieID: Int) -> AsyncThrowingStream<
        ImageCollection?, Error
    > {
        let descriptor = FetchDescriptor<ImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        let stream = stream(for: descriptor) {
            ImageCollectionMapper().compactMap($0.first)
        }

        return stream
    }

    func setImageCollection(
        _ imageCollection: ImageCollection
    ) async throws(MovieImageLocalDataSourceError) {
        let movieID = imageCollection.id
        let descriptor = FetchDescriptor<ImageCollectionEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        let mapper = ImageCollectionMapper()
        let existing: ImageCollectionEntity?
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

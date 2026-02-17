//
//  SwiftDataMovieCreditsLocalDataSource.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataMovieCreditsLocalDataSource: MovieCreditsLocalDataSource, SwiftDataFetchStreaming {

    private static let logger = Logger.moviesInfrastructure

    private var ttl: TimeInterval = 60 * 60 * 24 // 1 day

    func credits(forMovie movieID: Int) async throws(MovieCreditsLocalDataSourceError) -> Credits? {
        let entity: CreditsEntity?
        var descriptor = FetchDescriptor<CreditsEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        descriptor.fetchLimit = 1

        do {
            entity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        guard let entity else {
            Self.logger.debug("SwiftData MISS: Credits(movie-id: \(movieID, privacy: .public))")
            return nil
        }

        guard !entity.isExpired(ttl: ttl) else {
            Self.logger.debug(
                "SwiftData EXPIRED: Credits(movie-id: \(movieID, privacy: .public)) - deleting"
            )
            modelContext.delete(entity)
            do {
                try modelContext.save()
            } catch let error {
                throw .persistence(error)
            }
            return nil
        }

        Self.logger.debug("SwiftData HIT: Credits(movie-id: \(movieID, privacy: .public))")

        let mapper = CreditsEntityMapper()
        return mapper.map(entity)
    }

    func setCredits(
        _ credits: Credits,
        forMovie movieID: Int
    ) async throws(MovieCreditsLocalDataSourceError) {
        let descriptor = FetchDescriptor<CreditsEntity>(
            predicate: #Predicate { $0.movieID == movieID }
        )
        let existing: CreditsEntity?

        do {
            existing = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        let mapper = CreditsEntityMapper()

        if let existing {
            // Delete existing cast/crew first (cascade only triggers on parent delete)
            existing.cast.forEach { modelContext.delete($0) }
            existing.crew.forEach { modelContext.delete($0) }

            mapper.map(credits, movieID: movieID, to: existing)
        } else {
            let entity = mapper.map(credits, movieID: movieID)
            modelContext.insert(entity)
        }

        do {
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}

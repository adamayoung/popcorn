//
//  SwiftDataMovieWatchlistLocalDataSource.swift
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
actor SwiftDataMovieWatchlistLocalDataSource: MovieWatchlistLocalDataSource,
SwiftDataFetchStreaming {

    func movies() async throws(MovieWatchlistLocalDataSourceError) -> Set<WatchlistMovie> {
        let descriptor = FetchDescriptor<MoviesWatchlistMovieEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        let entities: [MoviesWatchlistMovieEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = WatchlistMovieMapper()
        let watchlistMovies = entities.compactMap(mapper.map)

        return Set(watchlistMovies)
    }

    func isOnWatchlist(movieID id: Int) async throws(MovieWatchlistLocalDataSourceError) -> Bool {
        var descriptor = FetchDescriptor<MoviesWatchlistMovieEntity>(
            predicate: #Predicate { $0.movieID == id },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let watchlistMovieEntity: MoviesWatchlistMovieEntity?
        do {
            watchlistMovieEntity = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return watchlistMovieEntity != nil
    }

    func addMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError) {
        let watchlistMovieEntity = MoviesWatchlistMovieEntity(movieID: id, createdAt: .now)
        modelContext.insert(watchlistMovieEntity)

        do { try modelContext.save() } catch let error {
            throw .persistence(error)
        }
    }

    func removeMovie(
        withID id: Int
    ) async throws(MovieWatchlistLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<MoviesWatchlistMovieEntity>(
            predicate: #Predicate { $0.movieID == id }
        )
        do {
            let entitiesToDelete = try modelContext.fetch(deleteDescriptor)
            entitiesToDelete.forEach(modelContext.delete)
            try modelContext.save()
        } catch let error {
            throw .persistence(error)
        }
    }

}

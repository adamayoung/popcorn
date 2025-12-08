//
//  SwiftDataFavouriteMovieLocalDataSource.swift
//  MoviesKit
//
//  Created by Adam Young on 03/12/2025.
//

import DataPersistenceInfrastructure
import Foundation
import MoviesDomain
import OSLog
import SwiftData

@ModelActor
actor SwiftDataFavouriteMovieLocalDataSource: FavouriteMovieLocalDataSource,
    SwiftDataFetchStreaming, Sendable
{

    private static let logger = Logger(
        subsystem: "MoviesKit",
        category: "SwiftDataFavouriteMovieLocalDataSource"
    )

    func favourites() async throws(FavouriteMovieLocalDataSourceError) -> Set<FavouriteMovie> {
        let descriptor = FetchDescriptor<FavouriteMovieEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        let entities: [FavouriteMovieEntity]
        do {
            entities = try modelContext.fetch(descriptor)
        } catch let error {
            throw .persistence(error)
        }

        let mapper = FavouriteMovieMapper()
        let favouriteMovies = entities.compactMap(mapper.map)

        return Set(favouriteMovies)
    }

    func isFavourite(movieID id: Int) async throws(FavouriteMovieLocalDataSourceError) -> Bool {
        var descriptor = FetchDescriptor<FavouriteMovieEntity>(
            predicate: #Predicate { $0.movieID == id },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let favouriteMovie: FavouriteMovieEntity?
        do {
            favouriteMovie = try modelContext.fetch(descriptor).first
        } catch let error {
            throw .persistence(error)
        }

        return favouriteMovie != nil
    }

    func saveFavourite(
        withID id: Int
    ) async throws(FavouriteMovieLocalDataSourceError) {
        let favouriteMovieEntity = FavouriteMovieEntity(movieID: id, createdAt: .now)
        modelContext.insert(favouriteMovieEntity)

        do { try modelContext.save() } catch let error {
            throw .persistence(error)
        }
    }

    func deleteFavourite(
        withID id: Int
    ) async throws(MoviesDomain.FavouriteMovieLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<FavouriteMovieEntity>(
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

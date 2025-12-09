//
//  SwiftDataFavouriteMovieLocalDataSource.swift
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
actor SwiftDataFavouriteMovieLocalDataSource: FavouriteMovieLocalDataSource,
    SwiftDataFetchStreaming, Sendable
{

    private static let logger = Logger(
        subsystem: "PopcornMovies",
        category: "SwiftDataFavouriteMovieLocalDataSource"
    )

    func favourites() async throws(FavouriteMovieLocalDataSourceError) -> Set<FavouriteMovie> {
        let descriptor = FetchDescriptor<MoviesFavouriteMovieEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        let entities: [MoviesFavouriteMovieEntity]
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
        var descriptor = FetchDescriptor<MoviesFavouriteMovieEntity>(
            predicate: #Predicate { $0.movieID == id },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1

        let favouriteMovie: MoviesFavouriteMovieEntity?
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
        let favouriteMovieEntity = MoviesFavouriteMovieEntity(movieID: id, createdAt: .now)
        modelContext.insert(favouriteMovieEntity)

        do { try modelContext.save() } catch let error {
            throw .persistence(error)
        }
    }

    func deleteFavourite(
        withID id: Int
    ) async throws(MoviesDomain.FavouriteMovieLocalDataSourceError) {
        let deleteDescriptor = FetchDescriptor<MoviesFavouriteMovieEntity>(
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

//
//  MoviesInfrastructureFactory.swift
//  PopcornMovies
//
//  Created by Adam Young on 18/11/2025.
//

import Caching
import Foundation
import MoviesDomain
import SwiftData

package final class MoviesInfrastructureFactory {

    private static let modelContainer: ModelContainer = {
        let schema = Schema([
            MovieEntity.self,
            ImageCollectionEntity.self,
            MoviePreviewEntity.self,
            PopularMovieItemEntity.self,
            SimilarMovieItemEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "movieskit.sqlite")
        let config = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            fatalError("MoviesKit: Cannot configure ModelContainer: \(error.localizedDescription)")
        }
    }()

    private static let cloudKitModelContainer: ModelContainer = {
        let schema = Schema([
            FavouriteMovieEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "movieskit-cloudkit.sqlite")
        let config = ModelConfiguration(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: .private("iCloud.uk.co.adam-young.Movies")
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            fatalError(
                "MoviesKit: Cannot configure CloudKit ModelContainer: \(error.localizedDescription)"
            )
        }
    }()

    private let movieRemoteDataSource: any MovieRemoteDataSource

    package init(movieRemoteDataSource: some MovieRemoteDataSource) {
        self.movieRemoteDataSource = movieRemoteDataSource
    }

    package func makeMovieRepository() -> some MovieRepository {
        DefaultMovieRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.movieLocalDataSource
        )
    }

    package func makeFavouriteMovieRepository() -> some FavouriteMovieRepository {
        DefaultFavouriteMovieRepository(
            localDataSource: Self.favouriteMovieLocalDataSource
        )
    }

    package func makeMovieImageRepository() -> some MovieImageRepository {
        DefaultMovieImageRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.movieImageLocalDataSource
        )
    }

    package func makePopularMovieRepository() -> some PopularMovieRepository {
        DefaultPopularMovieRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.popularMovieLocalDataSource
        )
    }

    package func makeSimilarMovieRepository() -> some SimilarMovieRepository {
        DefaultSimilarMovieRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.similarMovieLocalDataSource
        )
    }

}

extension MoviesInfrastructureFactory {

    private static let movieLocalDataSource = SwiftDataMovieLocalDataSource(
        modelContainer: modelContainer
    )

    private static let favouriteMovieLocalDataSource = SwiftDataFavouriteMovieLocalDataSource(
        modelContainer: cloudKitModelContainer
    )

    private static let movieImageLocalDataSource = SwiftDataMovieImageLocalDataSource(
        modelContainer: modelContainer
    )

    private static let popularMovieLocalDataSource = SwiftDataPopularMovieLocalDataSource(
        modelContainer: modelContainer
    )

    private static let similarMovieLocalDataSource = SwiftDataSimilarMovieLocalDataSource(
        modelContainer: modelContainer
    )

}

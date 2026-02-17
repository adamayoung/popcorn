//
//  MoviesInfrastructureFactory.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Caching
import Foundation
import MoviesDomain
import OSLog
import SwiftData

package final class MoviesInfrastructureFactory {

    private static let logger = Logger.moviesInfrastructure

    private static let modelContainer: ModelContainer = {
        let schema = Schema([
            MoviesMovieEntity.self,
            MoviesImageCollectionEntity.self,
            MoviesMoviePreviewEntity.self,
            MoviesPopularMovieItemEntity.self,
            MoviesSimilarMovieItemEntity.self,
            MoviesRecommendationMovieItemEntity.self,
            CreditsEntity.self,
            CastMemberEntity.self,
            CrewMemberEntity.self,
            MoviesMovieCertificationEntity.self,
            MoviesGenreEntity.self,
            MoviesProductionCompanyEntity.self,
            MoviesProductionCountryEntity.self,
            MoviesSpokenLanguageEntity.self,
            MoviesMovieCollectionEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies.sqlite")
        let config = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            logger.critical(
                "Cannot configure ModelContainer: \(error.localizedDescription, privacy: .public)"
            )
            fatalError(
                "PopcornMovies: Cannot configure ModelContainer: \(error.localizedDescription)"
            )
        }
    }()

    private static let cloudKitModelContainer: ModelContainer = {
        let schema = Schema([
            MoviesWatchlistMovieEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies-cloudkit.sqlite")
        let config = ModelConfiguration(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn")
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            logger.critical(
                "Cannot configure CloudKit ModelContainer: \(error.localizedDescription, privacy: .public)"
            )
            fatalError(
                "PopcornMovies: Cannot configure CloudKit ModelContainer: \(error.localizedDescription)"
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

    package func makeMovieWatchlistRepository() -> some MovieWatchlistRepository {
        DefaultMovieWatchlistRepository(
            localDataSource: Self.movieWatchlistLocalDataSource
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

    package func makeMovieRecommendationRepository() -> some MovieRecommendationRepository {
        DefaultMovieRecommendationRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.movieRecommendationLocalDataSource
        )
    }

    package func makeMovieCreditsRepository() -> some MovieCreditsRepository {
        DefaultMovieCreditsRepository(
            remoteDataSource: movieRemoteDataSource,
            localDataSource: Self.movieCreditsLocalDataSource
        )
    }

}

extension MoviesInfrastructureFactory {

    private static let movieLocalDataSource: some MovieLocalDataSource =
        SwiftDataMovieLocalDataSource(
            modelContainer: modelContainer
        )

    private static let movieWatchlistLocalDataSource: some MovieWatchlistLocalDataSource =
        SwiftDataMovieWatchlistLocalDataSource(
            modelContainer: cloudKitModelContainer
        )

    private static let movieImageLocalDataSource: some MovieImageLocalDataSource =
        SwiftDataMovieImageLocalDataSource(
            modelContainer: modelContainer
        )

    private static let popularMovieLocalDataSource: some PopularMovieLocalDataSource =
        SwiftDataPopularMovieLocalDataSource(
            modelContainer: modelContainer
        )

    private static let similarMovieLocalDataSource: some SimilarMovieLocalDataSource =
        SwiftDataSimilarMovieLocalDataSource(
            modelContainer: modelContainer
        )

    private static let movieRecommendationLocalDataSource: some MovieRecommendationLocalDataSource =
        SwiftDataMovieRecommendationLocalDataSource(
            modelContainer: modelContainer
        )

    private static let movieCreditsLocalDataSource: some MovieCreditsLocalDataSource =
        SwiftDataMovieCreditsLocalDataSource(
            modelContainer: modelContainer
        )

}

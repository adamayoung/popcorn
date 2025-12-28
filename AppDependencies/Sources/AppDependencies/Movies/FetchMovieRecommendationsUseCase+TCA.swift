//
//  FetchMovieRecommendationsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieRecommendationsUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieRecommendationsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieRecommendationsUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching recommended movies based on a given movie.
    ///
    /// Retrieves a list of movies that are recommended for users who liked
    /// the specified movie.
    ///
    var fetchMovieRecommendations: any FetchMovieRecommendationsUseCase {
        get { self[FetchMovieRecommendationsUseCaseKey.self] }
        set { self[FetchMovieRecommendationsUseCaseKey.self] = newValue }
    }

}

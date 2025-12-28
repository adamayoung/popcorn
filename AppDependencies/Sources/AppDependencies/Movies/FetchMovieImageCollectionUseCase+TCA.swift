//
//  FetchMovieImageCollectionUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum FetchMovieImageCollectionUseCaseKey: DependencyKey {

    static var liveValue: any FetchMovieImageCollectionUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieImageCollectionUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching a collection of images for a specific movie.
    ///
    /// Retrieves posters, backdrops, and logo images associated with a movie.
    ///
    var fetchMovieImageCollection: any FetchMovieImageCollectionUseCase {
        get { self[FetchMovieImageCollectionUseCaseKey.self] }
        set { self[FetchMovieImageCollectionUseCaseKey.self] = newValue }
    }

}

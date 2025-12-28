//
//  ToggleWatchlistMovieUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum ToggleWatchlistMovieUseCaseKey: DependencyKey {

    static var liveValue: any ToggleWatchlistMovieUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeToggleWatchlistMovieUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for toggling a movie's presence in the user's watchlist.
    ///
    /// Adds or removes a movie from the user's watchlist based on its
    /// current state.
    ///
    var toggleWatchlistMovie: any ToggleWatchlistMovieUseCase {
        get { self[ToggleWatchlistMovieUseCaseKey.self] }
        set { self[ToggleWatchlistMovieUseCaseKey.self] = newValue }
    }

}

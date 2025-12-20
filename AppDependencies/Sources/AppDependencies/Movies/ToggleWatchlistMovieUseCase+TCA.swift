//
//  ToggleWatchlistMovieUseCase+TCA.swift
//  Popcorn
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

    var toggleWatchlistMovie: any ToggleWatchlistMovieUseCase {
        get { self[ToggleWatchlistMovieUseCaseKey.self] }
        set { self[ToggleWatchlistMovieUseCaseKey.self] = newValue }
    }

}

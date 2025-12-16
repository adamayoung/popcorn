//
//  ToggleFavouriteMovieUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 03/12/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum ToggleWatchlistMovieUseCaseKey: DependencyKey {

    static var liveValue: any ToggleWatchlistMovieUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeToggleFavouriteMovieUseCase()
    }

}

extension DependencyValues {

    public var toggleWatchlistMovie: any ToggleWatchlistMovieUseCase {
        get { self[ToggleWatchlistMovieUseCaseKey.self] }
        set { self[ToggleWatchlistMovieUseCaseKey.self] = newValue }
    }

}

//
//  ToggleFavouriteMovieUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 03/12/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum ToggleFavouriteMovieUseCaseKey: DependencyKey {

    static var liveValue: any ToggleFavouriteMovieUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeToggleFavouriteMovieUseCase()
    }

}

extension DependencyValues {

    public var toggleFavouriteMovie: any ToggleFavouriteMovieUseCase {
        get { self[ToggleFavouriteMovieUseCaseKey.self] }
        set { self[ToggleFavouriteMovieUseCaseKey.self] = newValue }
    }

}

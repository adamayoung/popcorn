//
//  StreamMovieDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamMovieDetailsUseCaseKey: DependencyKey {

    static var liveValue: any StreamMovieDetailsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeStreamMovieDetailsUseCase()
    }

}

public extension DependencyValues {

    var streamMovieDetails: any StreamMovieDetailsUseCase {
        get { self[StreamMovieDetailsUseCaseKey.self] }
        set { self[StreamMovieDetailsUseCaseKey.self] = newValue }
    }

}

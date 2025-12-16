//
//  StreamMovieDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 02/12/2025.
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

extension DependencyValues {

    public var streamMovieDetails: any StreamMovieDetailsUseCase {
        get { self[StreamMovieDetailsUseCaseKey.self] }
        set { self[StreamMovieDetailsUseCaseKey.self] = newValue }
    }

}

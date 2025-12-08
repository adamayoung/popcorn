//
//  StreamMovieDetailsUseCase+TCA.swift
//  PopcornMoviesAdapters
//
//  Created by Adam Young on 02/12/2025.
//

import ComposableArchitecture
import Foundation
import MoviesApplication

enum StreamMovieDetailsUseCaseKey: DependencyKey {

    static var liveValue: any StreamMovieDetailsUseCase {
        DependencyValues._current
            .moviesFactory
            .makeStreamMovieDetailsUseCase()
    }

}

extension DependencyValues {

    public var streamMovieDetails: any StreamMovieDetailsUseCase {
        get { self[StreamMovieDetailsUseCaseKey.self] }
        set { self[StreamMovieDetailsUseCaseKey.self] = newValue }
    }

}

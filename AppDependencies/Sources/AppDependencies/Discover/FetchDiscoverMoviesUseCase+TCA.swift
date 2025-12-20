//
//  FetchDiscoverMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DiscoverApplication
import Foundation

enum FetchDiscoverMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchDiscoverMoviesUseCase {
        @Dependency(\.discoverFactory) var discoverFactory
        return discoverFactory.makeFetchDiscoverMoviesUseCase()
    }

}

public extension DependencyValues {

    var fetchDiscoverMovies: any FetchDiscoverMoviesUseCase {
        get { self[FetchDiscoverMoviesUseCaseKey.self] }
        set { self[FetchDiscoverMoviesUseCaseKey.self] = newValue }
    }

}

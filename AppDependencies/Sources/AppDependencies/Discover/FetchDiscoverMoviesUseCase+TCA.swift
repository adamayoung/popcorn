//
//  FetchDiscoverMoviesUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 09/12/2025.
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

extension DependencyValues {

    public var fetchDiscoverMovies: any FetchDiscoverMoviesUseCase {
        get { self[FetchDiscoverMoviesUseCaseKey.self] }
        set { self[FetchDiscoverMoviesUseCaseKey.self] = newValue }
    }

}

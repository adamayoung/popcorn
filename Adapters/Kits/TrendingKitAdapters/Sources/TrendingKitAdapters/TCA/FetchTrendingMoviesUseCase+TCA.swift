//
//  FetchTrendingMoviesUseCase+TCA.swift
//  TrendingKitAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TMDbAdapters
import TrendingApplication

enum FetchTrendingMoviesUseCaseKey: DependencyKey {

    static var liveValue: any FetchTrendingMoviesUseCase {
        DependencyValues._current
            .trendingFactory
            .makeFetchTrendingMoviesUseCase()
    }

}

extension DependencyValues {

    public var fetchTrendingMovies: any FetchTrendingMoviesUseCase {
        get { self[FetchTrendingMoviesUseCaseKey.self] }
        set { self[FetchTrendingMoviesUseCaseKey.self] = newValue }
    }

}

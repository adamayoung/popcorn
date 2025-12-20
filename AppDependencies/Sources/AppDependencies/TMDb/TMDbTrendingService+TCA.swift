//
//  TMDbTrendingService+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbTrendingServiceKey: DependencyKey {

    static var liveValue: TrendingService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.trending
    }

}

extension DependencyValues {

    var trendingService: TrendingService {
        get { self[TMDbTrendingServiceKey.self] }
        set { self[TMDbTrendingServiceKey.self] = newValue }
    }

}

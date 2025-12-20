//
//  TMDbTVSeriesService+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbTVSeriesServiceKey: DependencyKey {

    static var liveValue: TVSeriesService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.tvSeries
    }

}

extension DependencyValues {

    var tvSeriesService: TVSeriesService {
        get { self[TMDbTVSeriesServiceKey.self] }
        set { self[TMDbTVSeriesServiceKey.self] = newValue }
    }

}

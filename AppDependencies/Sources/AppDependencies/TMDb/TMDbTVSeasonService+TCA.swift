//
//  TMDbTVSeasonService+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbTVSeasonServiceKey: DependencyKey {

    static var liveValue: TVSeasonService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.tvSeasons
    }

}

extension DependencyValues {

    var tvSeasonService: TVSeasonService {
        get { self[TMDbTVSeasonServiceKey.self] }
        set { self[TMDbTVSeasonServiceKey.self] = newValue }
    }

}

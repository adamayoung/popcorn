//
//  TMDbTVEpisodeService+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbTVEpisodeServiceKey: DependencyKey {

    static var liveValue: TVEpisodeService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.tvEpisodes
    }

}

extension DependencyValues {

    var tvEpisodeService: TVEpisodeService {
        get { self[TMDbTVEpisodeServiceKey.self] }
        set { self[TMDbTVEpisodeServiceKey.self] = newValue }
    }

}

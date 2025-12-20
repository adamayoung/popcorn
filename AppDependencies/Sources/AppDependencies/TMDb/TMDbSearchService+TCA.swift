//
//  TMDbSearchService+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbSearchServiceKey: DependencyKey {

    static var liveValue: SearchService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.search
    }

}

extension DependencyValues {

    var searchService: SearchService {
        get { self[TMDbSearchServiceKey.self] }
        set { self[TMDbSearchServiceKey.self] = newValue }
    }

}

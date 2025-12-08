//
//  TMDbSearchService+TCA.swift
//  TMDbAdapters
//
//  Created by Adam Young on 25/11/2025.
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

    public var searchService: SearchService {
        get { self[TMDbSearchServiceKey.self] }
        set { self[TMDbSearchServiceKey.self] = newValue }
    }

}

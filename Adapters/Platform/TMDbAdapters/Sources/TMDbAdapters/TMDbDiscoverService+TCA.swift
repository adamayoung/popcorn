//
//  TMDbDiscoverService+TCA.swift
//  TMDbAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbDiscoverServiceKey: DependencyKey {

    static var liveValue: DiscoverService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.discover
    }

}

extension DependencyValues {

    public var discoverService: DiscoverService {
        get { self[TMDbDiscoverServiceKey.self] }
        set { self[TMDbDiscoverServiceKey.self] = newValue }
    }

}

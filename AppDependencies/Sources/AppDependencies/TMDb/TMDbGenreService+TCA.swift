//
//  TMDbGenreService+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbGenreServiceKey: DependencyKey {

    static var liveValue: GenreService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.genres
    }

}

extension DependencyValues {

    var genreService: GenreService {
        get { self[TMDbGenreServiceKey.self] }
        set { self[TMDbGenreServiceKey.self] = newValue }
    }

}

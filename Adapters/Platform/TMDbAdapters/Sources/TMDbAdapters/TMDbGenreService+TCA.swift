//
//  TMDbGenreService+TCA.swift
//  TMDbAdapters
//
//  Created by Adam Young on 18/11/2025.
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

    public var genreService: GenreService {
        get { self[TMDbGenreServiceKey.self] }
        set { self[TMDbGenreServiceKey.self] = newValue }
    }

}

//
//  TMDbMovieService+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbMovieServiceKey: DependencyKey {

    static var liveValue: MovieService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.movies
    }

}

extension DependencyValues {

    var movieService: MovieService {
        get { self[TMDbMovieServiceKey.self] }
        set { self[TMDbMovieServiceKey.self] = newValue }
    }

}

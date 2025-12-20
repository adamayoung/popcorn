//
//  TMDbPersonService+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbPersonServiceKey: DependencyKey {

    static var liveValue: PersonService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.people
    }

}

extension DependencyValues {

    var personService: PersonService {
        get { self[TMDbPersonServiceKey.self] }
        set { self[TMDbPersonServiceKey.self] = newValue }
    }

}

//
//  TMDbConfigurationService+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbConfigurationServiceKey: DependencyKey {

    static var liveValue: ConfigurationService {
        let tmdb = DependencyValues._current.tmdb
        return tmdb.configurations
    }

}

extension DependencyValues {

    var configurationService: ConfigurationService {
        get { self[TMDbConfigurationServiceKey.self] }
        set { self[TMDbConfigurationServiceKey.self] = newValue }
    }

}

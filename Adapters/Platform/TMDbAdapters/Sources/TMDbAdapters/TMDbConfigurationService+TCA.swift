//
//  TMDbConfigurationService+TCA.swift
//  TMDbAdapters
//
//  Created by Adam Young on 18/11/2025.
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

    public var configurationService: ConfigurationService {
        get { self[TMDbConfigurationServiceKey.self] }
        set { self[TMDbConfigurationServiceKey.self] = newValue }
    }

}

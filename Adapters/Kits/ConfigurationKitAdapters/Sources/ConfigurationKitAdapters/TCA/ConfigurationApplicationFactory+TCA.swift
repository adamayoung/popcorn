//
//  ConfigurationApplicationFactory+TCA.swift
//  MoviesKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationApplication
import Foundation
import TMDbAdapters

extension DependencyValues {

    var configurationFactory: ConfigurationApplicationFactory {
        ConfigurationKitAdaptersFactory(
            configurationService: self.configurationService
        ).makeConfigurationFactory()
    }

}

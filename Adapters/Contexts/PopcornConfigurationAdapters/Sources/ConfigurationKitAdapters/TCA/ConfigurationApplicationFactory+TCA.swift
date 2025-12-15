//
//  ConfigurationApplicationFactory+TCA.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationComposition
import Foundation
import TMDbAdapters

extension DependencyValues {

    var configurationFactory: PopcornConfigurationFactory {
        PopcornConfigurationAdaptersFactory(
            configurationService: self.configurationService
        ).makeConfigurationFactory()
    }

}

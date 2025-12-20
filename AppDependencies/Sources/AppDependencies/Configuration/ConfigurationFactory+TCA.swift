//
//  ConfigurationFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ConfigurationComposition
import Foundation
import PopcornConfigurationAdapters

extension DependencyValues {

    var configurationFactory: PopcornConfigurationFactory {
        PopcornConfigurationAdaptersFactory(
            configurationService: configurationService
        ).makeConfigurationFactory()
    }

}

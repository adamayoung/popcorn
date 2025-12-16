//
//  ConfigurationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationComposition
import Foundation
import PopcornConfigurationAdapters

extension DependencyValues {

    var configurationFactory: PopcornConfigurationFactory {
        PopcornConfigurationAdaptersFactory(
            configurationService: self.configurationService
        ).makeConfigurationFactory()
    }

}

//
//  ConfigurationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ConfigurationComposition
import Foundation
import PopcornConfigurationAdapters

enum PopcornConfigurationFactoryKey: DependencyKey {

    static var liveValue: PopcornConfigurationFactory {
        @Dependency(\.configurationService) var configurationService
        return PopcornConfigurationAdaptersFactory(
            configurationService: configurationService
        ).makeConfigurationFactory()
    }

}

extension DependencyValues {

    var configurationFactory: PopcornConfigurationFactory {
        get { self[PopcornConfigurationFactoryKey.self] }
        set { self[PopcornConfigurationFactoryKey.self] = newValue }
    }

}

//
//  FetchAppConfigurationUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ConfigurationApplication
import ConfigurationComposition
import Foundation
import PopcornConfigurationAdapters

enum FetchAppConfigurationUseCaseKey: DependencyKey {

    static var liveValue: any FetchAppConfigurationUseCase {
        @Dependency(\.configurationFactory) var configurationFactory
        return configurationFactory.makeFetchAppConfigurationUseCase()
    }

}

public extension DependencyValues {

    ///
    /// A use case for fetching the application configuration.
    ///
    /// Retrieves configuration data required for the app to function correctly,
    /// including image base URLs and supported image sizes.
    ///
    var fetchAppConfiguration: any FetchAppConfigurationUseCase {
        get { self[FetchAppConfigurationUseCaseKey.self] }
        set { self[FetchAppConfigurationUseCaseKey.self] = newValue }
    }

}

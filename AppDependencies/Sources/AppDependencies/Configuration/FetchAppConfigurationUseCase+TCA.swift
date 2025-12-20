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

    var fetchAppConfiguration: any FetchAppConfigurationUseCase {
        get { self[FetchAppConfigurationUseCaseKey.self] }
        set { self[FetchAppConfigurationUseCaseKey.self] = newValue }
    }

}

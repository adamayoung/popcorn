//
//  FetchAppConfigurationUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 26/11/2025.
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

extension DependencyValues {

    public var fetchAppConfiguration: any FetchAppConfigurationUseCase {
        get { self[FetchAppConfigurationUseCaseKey.self] }
        set { self[FetchAppConfigurationUseCaseKey.self] = newValue }
    }

}

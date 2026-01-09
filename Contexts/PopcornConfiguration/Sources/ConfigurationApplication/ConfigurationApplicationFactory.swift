//
//  ConfigurationApplicationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import Foundation

public final class ConfigurationApplicationFactory: Sendable {

    private let configurationRepository: any ConfigurationRepository

    public init(configurationRepository: some ConfigurationRepository) {
        self.configurationRepository = configurationRepository
    }

    public func makeFetchAppConfigurationUseCase() -> some FetchAppConfigurationUseCase {
        DefaultFetchAppConfigurationUseCase(
            repository: configurationRepository
        )
    }

}

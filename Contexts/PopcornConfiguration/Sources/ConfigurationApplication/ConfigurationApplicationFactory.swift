//
//  ConfigurationApplicationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationDomain
import Foundation

package final class ConfigurationApplicationFactory: Sendable {

    private let configurationRepository: any ConfigurationRepository

    package init(configurationRepository: some ConfigurationRepository) {
        self.configurationRepository = configurationRepository
    }

    package func makeFetchAppConfigurationUseCase() -> some FetchAppConfigurationUseCase {
        DefaultFetchAppConfigurationUseCase(
            repository: configurationRepository
        )
    }

}

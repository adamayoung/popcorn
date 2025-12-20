//
//  ConfigurationApplicationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import Foundation

package final class ConfigurationApplicationFactory {

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

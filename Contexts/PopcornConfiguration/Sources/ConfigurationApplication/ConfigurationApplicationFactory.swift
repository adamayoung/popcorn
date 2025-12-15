//
//  ConfigurationApplicationFactory.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 15/10/2025.
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

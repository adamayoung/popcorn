//
//  ConfigurationApplicationFactory.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 15/10/2025.
//

import ConfigurationDomain
import Foundation

public final class ConfigurationApplicationFactory {

    private let configurationRepository: any ConfigurationRepository

    init(configurationRepository: some ConfigurationRepository) {
        self.configurationRepository = configurationRepository
    }

    public func makeFetchAppConfigurationUseCase() -> some FetchAppConfigurationUseCase {
        DefaultFetchAppConfigurationUseCase(repository: configurationRepository)
    }

}

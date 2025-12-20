//
//  PopcornConfigurationFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import ConfigurationDomain
import ConfigurationInfrastructure
import Foundation

public final class PopcornConfigurationFactory {

    private let applicationFactory: ConfigurationApplicationFactory

    public init(
        configurationRemoteDataSource: some ConfigurationRemoteDataSource
    ) {
        let infrastructureFactory = ConfigurationInfrastructureFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
        self.applicationFactory = ConfigurationApplicationFactory(
            configurationRepository: infrastructureFactory.makeConfigurationRepository()
        )
    }

    public func makeFetchAppConfigurationUseCase() -> some FetchAppConfigurationUseCase {
        applicationFactory.makeFetchAppConfigurationUseCase()
    }

}

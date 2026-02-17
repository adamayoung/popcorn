//
//  LivePopcornConfigurationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import ConfigurationDomain
import ConfigurationInfrastructure
import Foundation

public final class LivePopcornConfigurationFactory: PopcornConfigurationFactory {

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

    public func makeFetchAppConfigurationUseCase() -> FetchAppConfigurationUseCase {
        applicationFactory.makeFetchAppConfigurationUseCase()
    }

}

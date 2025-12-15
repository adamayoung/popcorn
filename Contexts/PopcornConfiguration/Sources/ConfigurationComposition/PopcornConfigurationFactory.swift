//
//  ConfigurationFactory.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 20/11/2025.
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

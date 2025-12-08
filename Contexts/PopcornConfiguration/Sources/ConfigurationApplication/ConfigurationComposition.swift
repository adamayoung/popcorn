//
//  ConfigurationComposition.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 20/11/2025.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import Foundation

public struct ConfigurationComposition {

    private init() {}

    public static func makeConfigurationFactory(
        configurationRemoteDataSource: some ConfigurationRemoteDataSource
    ) -> ConfigurationApplicationFactory {
        let infrastructureFactory = ConfigurationInfrastructureFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
        let configurationRepository = infrastructureFactory.makeConfigurationRepository()

        return ConfigurationApplicationFactory(
            configurationRepository: configurationRepository
        )
    }

}

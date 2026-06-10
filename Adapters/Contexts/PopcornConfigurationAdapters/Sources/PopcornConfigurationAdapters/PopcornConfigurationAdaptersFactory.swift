//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationInfrastructure
import TMDb

/// Builds the Configuration context's TMDb-backed adapters (port implementations).
public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    public func makeConfigurationRemoteDataSource() -> some ConfigurationRemoteDataSource {
        TMDbConfigurationRemoteDataSource(configurationService: configurationService)
    }

}

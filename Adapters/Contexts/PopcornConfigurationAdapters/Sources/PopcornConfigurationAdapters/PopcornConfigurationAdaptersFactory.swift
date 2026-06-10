//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationInfrastructure
import TMDb

/// Builds the Configuration context's TMDb-backed adapters (port implementations).
///
/// This factory is responsible only for adapting external services to the
/// Configuration context's ports. Assembling the context's factory from these
/// adapters is the composition root's responsibility, so the adapters layer stays
/// a leaf and never depends on the context's composition module.
public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    public func makeConfigurationRemoteDataSource() -> some ConfigurationRemoteDataSource {
        TMDbConfigurationRemoteDataSource(configurationService: configurationService)
    }

}

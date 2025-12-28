//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationComposition
import Foundation
import TMDb

///
/// A factory for creating configuration-related adapters.
///
/// Creates adapters that bridge TMDb configuration services to the application's
/// configuration domain.
///
public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    ///
    /// Creates a configuration adapters factory.
    ///
    /// - Parameter configurationService: The TMDb configuration service.
    ///
    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    ///
    /// Creates a configuration factory with configured adapters.
    ///
    /// - Returns: A configured ``PopcornConfigurationFactory`` instance.
    ///
    public func makeConfigurationFactory() -> PopcornConfigurationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return PopcornConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}

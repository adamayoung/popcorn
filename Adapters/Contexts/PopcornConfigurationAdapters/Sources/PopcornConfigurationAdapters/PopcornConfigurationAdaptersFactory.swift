//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationComposition
import Foundation
import TMDb

public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    public func makeConfigurationFactory() -> some PopcornConfigurationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return LivePopcornConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}

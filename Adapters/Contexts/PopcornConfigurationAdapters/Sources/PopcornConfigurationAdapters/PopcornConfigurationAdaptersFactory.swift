//
//  PopcornConfigurationAdaptersFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationComposition
import Foundation
import TMDb

public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    public func makeConfigurationFactory() -> PopcornConfigurationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return PopcornConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}

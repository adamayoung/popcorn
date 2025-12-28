//
//  PopcornConfigurationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import ConfigurationDomain
import ConfigurationInfrastructure
import Foundation

///
/// A factory for creating configuration-related use cases.
///
/// Use this factory to obtain instances of use cases for fetching application configuration.
/// It handles the composition of all required dependencies internally.
///
public final class PopcornConfigurationFactory {

    private let applicationFactory: ConfigurationApplicationFactory

    /// Creates a new configuration factory.
    ///
    /// - Parameter configurationRemoteDataSource: The remote data source for fetching configuration.
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

    /// Creates a use case for fetching application configuration.
    ///
    /// - Returns: A configured ``FetchAppConfigurationUseCase`` instance.
    public func makeFetchAppConfigurationUseCase() -> some FetchAppConfigurationUseCase {
        applicationFactory.makeFetchAppConfigurationUseCase()
    }

}

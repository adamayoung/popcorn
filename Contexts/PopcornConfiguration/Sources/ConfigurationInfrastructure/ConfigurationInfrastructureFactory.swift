//
//  ConfigurationInfrastructureFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import Caching
import ConfigurationDomain
import Foundation

package final class ConfigurationInfrastructureFactory {

    private static let cache: some Caching = CachesFactory.makeInMemoryCache(defaultExpiresIn: 60)

    private let configurationRemoteDataSource: any ConfigurationRemoteDataSource

    package init(configurationRemoteDataSource: some ConfigurationRemoteDataSource) {
        self.configurationRemoteDataSource = configurationRemoteDataSource
    }

    package func makeConfigurationRepository() -> some ConfigurationRepository {
        let localDataSource = makeConfigurationLocalDataSource()

        return DefaultConfigurationRepository(
            remoteDataSource: configurationRemoteDataSource,
            localDataSource: localDataSource
        )
    }

}

extension ConfigurationInfrastructureFactory {

    private func makeConfigurationLocalDataSource() -> some ConfigurationLocalDataSource {
        let cache = makeCache()
        return CachedConfigurationLocalDataSource(cache: cache)
    }

}

extension ConfigurationInfrastructureFactory {

    private func makeCache() -> some Caching {
        Self.cache
    }

}

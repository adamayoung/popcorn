//
//  DefaultConfigurationRepository.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation

final class DefaultConfigurationRepository: ConfigurationRepository {

    private let remoteDataSource: any ConfigurationRemoteDataSource
    private let localDataSource: any ConfigurationLocalDataSource

    init(
        remoteDataSource: some ConfigurationRemoteDataSource,
        localDataSource: some ConfigurationLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func configuration(
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(ConfigurationRepositoryError) -> AppConfiguration {
        switch cachePolicy {
        case .cacheFirst:
            if let cachedAppConfiguration = await localDataSource.configuration() {
                return cachedAppConfiguration
            }

            let appConfiguration = try await remoteDataSource.configuration()
            await localDataSource.setConfiguration(appConfiguration)

            return appConfiguration

        case .networkOnly:
            let appConfiguration = try await remoteDataSource.configuration()
            await localDataSource.setConfiguration(appConfiguration)

            return appConfiguration

        case .cacheOnly:
            if let cachedAppConfiguration = await localDataSource.configuration() {
                return cachedAppConfiguration
            }

            throw .cacheUnavailable
        }
    }

}

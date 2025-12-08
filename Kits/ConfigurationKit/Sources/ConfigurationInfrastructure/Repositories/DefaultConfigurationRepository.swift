//
//  DefaultConfigurationRepository.swift
//  ConfigurationKit
//
//  Created by Adam Young on 29/05/2025.
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

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        if let cachedAppConfiguration = await localDataSource.configuration() {
            return cachedAppConfiguration
        }

        let appConfiguration = try await remoteDataSource.configuration()
        await localDataSource.setConfiguration(appConfiguration)

        return appConfiguration
    }

}

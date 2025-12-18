//
//  DefaultConfigurationRepository.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 29/05/2025.
//

import ConfigurationDomain
import CoreDomain
import Foundation
import Observability

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
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch App Configuration"
        )

        if let cachedAppConfiguration = await localDataSource.configuration() {
            span?.setData(key: "cache.hit", value: true)
            span?.finish()
            return cachedAppConfiguration
        }

        span?.setData(key: "cache.hit", value: false)
        let appConfiguration = try await remoteDataSource.configuration()
        await localDataSource.setConfiguration(appConfiguration)
        span?.finish()

        return appConfiguration
    }

}

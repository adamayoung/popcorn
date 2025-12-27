//
//  DefaultConfigurationRepository.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
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

    func configuration(
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(ConfigurationRepositoryError) -> AppConfiguration {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch App Configuration"
        )
        span?.setData(key: "cache.policy", value: String(describing: cachePolicy))

        switch cachePolicy {
        case .cacheFirst:
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

        case .networkOnly:
            span?.setData(key: "cache.hit", value: false)
            let appConfiguration = try await remoteDataSource.configuration()
            await localDataSource.setConfiguration(appConfiguration)
            span?.finish()

            return appConfiguration

        case .cacheOnly:
            if let cachedAppConfiguration = await localDataSource.configuration() {
                span?.setData(key: "cache.hit", value: true)
                span?.finish()
                return cachedAppConfiguration
            }

            span?.setData(key: "cache.hit", value: false)
            span?.finish(status: .internalError)
            throw .cacheUnavailable
        }
    }

}

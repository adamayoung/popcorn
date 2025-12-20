//
//  CachedConfigurationLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Caching
import ConfigurationDomain
import CoreDomain
import Foundation
import Observability

actor CachedConfigurationLocalDataSource: ConfigurationLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func configuration() async -> AppConfiguration? {
        let span = SpanContext.startChild(
            operation: .localDataSourceGet,
            description: "Get App Configuration"
        )

        let result = await cache.item(forKey: .appConfiguration, ofType: AppConfiguration.self)
        span?.finish()

        return result
    }

    func setConfiguration(_ appConfiguration: AppConfiguration) async {
        let span = SpanContext.startChild(
            operation: .localDataSourceSet,
            description: "Set App Configuration"
        )

        await cache.setItem(appConfiguration, forKey: .appConfiguration)
        span?.finish()
    }

}

extension CacheKey {

    static let appConfiguration = CacheKey(
        "PopcornConfiguration.ConfigurationInfrastructure.appConfiguration")

}

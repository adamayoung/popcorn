//
//  CachedConfigurationLocalDataSource.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 29/05/2025.
//

import Caching
import ConfigurationDomain
import CoreDomain
import Foundation

actor CachedConfigurationLocalDataSource: ConfigurationLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func configuration() async -> AppConfiguration? {
        await cache.item(forKey: .appConfiguration, ofType: AppConfiguration.self)
    }

    func setConfiguration(_ appConfiguration: AppConfiguration) async {
        await cache.setItem(appConfiguration, forKey: .appConfiguration)
    }

}

extension CacheKey {

    static let appConfiguration = CacheKey(
        "PopcornConfiguration.ConfigurationInfrastructure.appConfiguration")

}

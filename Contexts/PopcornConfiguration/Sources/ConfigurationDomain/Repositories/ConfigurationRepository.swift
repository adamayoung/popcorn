//
//  ConfigurationRepository.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol ConfigurationRepository: Sendable {

    func configuration(
        cachePolicy: CachePolicy
    ) async throws(ConfigurationRepositoryError) -> AppConfiguration

}

public extension ConfigurationRepository {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        try await configuration(cachePolicy: .cacheFirst)
    }

}

public enum ConfigurationRepositoryError: Error {

    case cacheUnavailable
    case unauthorised
    case unknown(Error? = nil)

}

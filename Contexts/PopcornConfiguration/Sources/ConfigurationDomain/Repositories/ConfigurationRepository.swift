//
//  ConfigurationRepository.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol ConfigurationRepository: Sendable {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}

public enum ConfigurationRepositoryError: Error {

    case unauthorised
    case unknown(Error? = nil)

}

//
//  ConfigurationRepository.swift
//  ConfigurationKit
//
//  Created by Adam Young on 18/11/2025.
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

//
//  ConfigurationRemoteDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation

public protocol ConfigurationRemoteDataSource: Sendable {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}

//
//  ConfigurationRemoteDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation

public protocol ConfigurationRemoteDataSource: Sendable {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}

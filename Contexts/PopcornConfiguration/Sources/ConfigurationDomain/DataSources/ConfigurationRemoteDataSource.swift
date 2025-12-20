//
//  ConfigurationRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol ConfigurationRemoteDataSource: Sendable {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}

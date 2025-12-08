//
//  ConfigurationRemoteDataSource.swift
//  ConfigurationKit
//
//  Created by Adam Young on 29/05/2025.
//

import CoreDomain
import Foundation

public protocol ConfigurationRemoteDataSource: Sendable {

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration

}

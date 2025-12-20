//
//  ObservabilityConfiguration.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct ObservabilityConfiguration: Sendable {

    public let dsn: String
    public let environment: Environment
    public let userID: String

    public init(
        dsn: String,
        environment: Environment,
        userID: String
    ) {
        self.dsn = dsn
        self.environment = environment
        self.userID = userID
    }

}

public extension ObservabilityConfiguration {

    enum Environment: String, Sendable {
        case development
        case staging
        case production
    }

}

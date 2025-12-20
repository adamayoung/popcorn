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

    public let isDebug: Bool

    public init(
        dsn: String,
        environment: Environment,
        userID: String,
        isDebug: Bool = false
    ) {
        self.dsn = dsn
        self.environment = environment
        self.userID = userID
        self.isDebug = isDebug
    }

}

public extension ObservabilityConfiguration {

    enum Environment: String, Sendable {
        case development
        case staging
        case production
    }

}

//
//  ObservabilityConfiguration.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
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

extension ObservabilityConfiguration {

    public enum Environment: String, Sendable {
        case development = "development"
        case staging = "staging"
        case production = "production"
    }

}

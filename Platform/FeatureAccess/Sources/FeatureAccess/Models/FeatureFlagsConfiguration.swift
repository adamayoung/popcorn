//
//  FeatureFlagsConfiguration.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct FeatureFlagsConfiguration: Sendable {

    public let apiKey: String
    public let environment: Environment
    public let userID: String

    public init(
        apiKey: String,
        environment: Environment,
        userID: String
    ) {
        self.apiKey = apiKey
        self.environment = environment
        self.userID = userID
    }

}

public extension FeatureFlagsConfiguration {

    enum Environment: String, Sendable {
        case development
        case staging
        case production
    }

}

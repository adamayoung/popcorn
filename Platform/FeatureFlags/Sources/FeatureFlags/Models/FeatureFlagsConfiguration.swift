//
//  FeatureFlagsConfiguration.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
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

extension FeatureFlagsConfiguration {

    public enum Environment: String, Sendable {
        case development = "development"
        case staging = "staging"
        case production = "production"
    }

}

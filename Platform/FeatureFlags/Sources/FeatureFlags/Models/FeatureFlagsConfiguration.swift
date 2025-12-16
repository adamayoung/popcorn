//
//  FeatureFlagsConfiguration.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public struct FeatureFlagsConfiguration: Sendable {

    public let userID: String
    public let environment: Environment
    public let apiKey: String

    public init(
        userID: String,
        environment: Environment,
        apiKey: String
    ) {
        self.userID = userID
        self.environment = environment
        self.apiKey = apiKey
    }

}

extension FeatureFlagsConfiguration {

    public enum Environment: String, Sendable {
        case development
        case staging
        case production
    }

}

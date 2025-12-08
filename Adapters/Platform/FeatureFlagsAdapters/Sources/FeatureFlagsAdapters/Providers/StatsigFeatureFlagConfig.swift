//
//  FeatureFlagConfig.swift
//  FeatureFlagsAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

public struct StatsigFeatureFlagConfig: Sendable {

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

extension StatsigFeatureFlagConfig {

    public enum Environment: String, Sendable {
        case development
        case staging
        case production
    }

}

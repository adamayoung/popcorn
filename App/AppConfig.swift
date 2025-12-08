//
//  AppSecrets.swift
//  Popcorn
//
//  Created by Adam Young on 26/11/2025.
//

import FeatureFlagsAdapters
import Foundation

struct AppConfig {

    static let statsigKey: String = {
        resolveValue(
            infoPlistKey: "StatsigSDKKey",
            environmentKey: "STATSIG_SDK_KEY"
        )
    }()

    static let statsigEnvironment: StatsigFeatureFlagConfig.Environment = {
        let raw = resolveValue(
            infoPlistKey: "StatsigEnvironment",
            environmentKey: "STATSIG_ENVIRONMENT"
        )

        guard let value = StatsigFeatureFlagConfig.Environment(rawValue: raw) else {
            fatalError("Invalid STATSIG_ENVIRONMENT: \(raw)")
        }

        return value
    }()

    private static func resolveValue(infoPlistKey: String, environmentKey: String) -> String {
        if let env = ProcessInfo.processInfo.environment[environmentKey],
            !env.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return env
        }

        if let value = Bundle.main.object(forInfoDictionaryKey: infoPlistKey) as? String,
            !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return value
        }

        fatalError("Missing \(environmentKey)")
    }

}

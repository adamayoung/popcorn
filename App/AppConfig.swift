//
//  AppSecrets.swift
//  Popcorn
//
//  Created by Adam Young on 26/11/2025.
//

import FeatureFlags
import Foundation
import Observability

enum AppConfig {

    enum Sentry {
        static let dsn: String = {
            AppConfig.resolveValue(
                infoPlistKey: "SentryDSN",
                environmentKey: "SENTRY_DSN"
            )
        }()

        static let environment: ObservabilityConfiguration.Environment = {
            let raw = AppConfig.resolveValue(
                infoPlistKey: "SentryEnvironment",
                environmentKey: "SENTRY_ENVIRONMENT"
            )

            guard let value = ObservabilityConfiguration.Environment(rawValue: raw) else {
                fatalError("Invalid SENTRY_ENVIRONMENT: \(raw)")
            }

            return value
        }()
    }

    enum Statsig {
        static let sdkKey: String = {
            AppConfig.resolveValue(
                infoPlistKey: "StatsigSDKKey",
                environmentKey: "STATSIG_SDK_KEY"
            )
        }()

        static let environment: FeatureFlagsConfiguration.Environment = {
            let raw = AppConfig.resolveValue(
                infoPlistKey: "StatsigEnvironment",
                environmentKey: "STATSIG_ENVIRONMENT"
            )

            guard let value = FeatureFlagsConfiguration.Environment(rawValue: raw) else {
                fatalError("Invalid STATSIG_ENVIRONMENT: \(raw)")
            }

            return value
        }()
    }

}

extension AppConfig {

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

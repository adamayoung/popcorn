//
//  AppConfig.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import FeatureFlags
import Foundation
import Observability

enum AppConfig {

    enum Sentry {
        static let dsn: String? = AppConfig.resolveValue(
            infoPlistKey: "SentryDSN",
            environmentKey: "SENTRY_DSN"
        )

        static let environment: ObservabilityConfiguration.Environment? = {
            guard
                let raw = AppConfig.resolveValue(
                    infoPlistKey: "SentryEnvironment",
                    environmentKey: "SENTRY_ENVIRONMENT"
                )
            else {
                return nil
            }

            guard let value = ObservabilityConfiguration.Environment(rawValue: raw) else {
                return nil
            }

            return value
        }()
    }

    enum Statsig {
        static let sdkKey: String? = AppConfig.resolveValue(
            infoPlistKey: "StatsigSDKKey",
            environmentKey: "STATSIG_SDK_KEY"
        )

        static let environment: FeatureFlagsConfiguration.Environment? = {
            guard
                let raw = AppConfig.resolveValue(
                    infoPlistKey: "StatsigEnvironment",
                    environmentKey: "STATSIG_ENVIRONMENT"
                )
            else {
                return nil
            }

            guard let value = FeatureFlagsConfiguration.Environment(rawValue: raw) else {
                return nil
            }

            return value
        }()
    }

}

extension AppConfig {

    private static func resolveValue(infoPlistKey: String, environmentKey: String) -> String? {
        if let env = ProcessInfo.processInfo.environment[environmentKey],
           !env.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return env
        }

        if let value = Bundle.main.object(forInfoDictionaryKey: infoPlistKey) as? String,
           !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return value
        }

        return nil
    }

}

//
//  AppConfig.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import FeatureAccess
import Foundation
import Observability

enum AppConfig {

    enum Amplitude {
        static let apiKey: String? = AppConfig.resolveValue(
            infoPlistKey: "AmplitudeAPIKey",
            environmentKey: "AMPLITUDE_API_KEY"
        )

        static let environment: AnalyticsConfiguration.Environment? = {
            guard
                let raw = AppConfig.resolveValue(
                    infoPlistKey: "AmplitudeEnvironment",
                    environmentKey: "AMPLITUDE_ENVIRONMENT"
                )
            else {
                return nil
            }

            guard let value = AnalyticsConfiguration.Environment(rawValue: raw) else {
                return nil
            }

            return value
        }()
    }

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

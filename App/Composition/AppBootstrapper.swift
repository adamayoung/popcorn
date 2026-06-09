//
//  AppBootstrapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import DesignSystem
import FeatureAccess
import Foundation
import Observability
import OSLog

/// Runs the app's one-time startup sequence against the shared ``AppServices`` graph.
///
/// The TCA-free replacement for `AppRootFeature.handleSetup` + `AppRootClient`'s
/// `setupObservability`/`setupFeatureFlags` `liveValue` bodies. ``start()`` warms the
/// image focal-point analyzer, then initialises observability and feature flags in
/// parallel.
///
/// Error handling mirrors the former reducer/client exactly:
/// - Observability swallows its own initialisation error (logged, not rethrown) so a
///   missing/failed Sentry setup never blocks app start.
/// - Feature flags rethrow on failure, so ``start()`` throws if feature-flag
///   initialisation fails — the caller (``AppRootViewModel``) surfaces the error.
struct AppBootstrapper {

    let services: AppServices

    private static let logger = Logger.appRoot

    func start() async throws {
        FocalPointAnalyzer.warmUp()

        let userID = AppInstallationIdentifier.userID()

        async let observability: Void = setupObservability(userID: userID)
        async let featureFlags: Void = setupFeatureFlags(userID: userID)

        _ = try await (observability, featureFlags)
    }

    /// Initialises observability. Mirrors `AppRootClient.liveValue.setupObservability`:
    /// returns early (logging) when Sentry is unconfigured, and swallows any
    /// initialisation error (logged, not rethrown).
    private func setupObservability(userID: String) async {
        guard let dsn = AppConfig.Sentry.dsn else {
            Self.logger.warning("Sentry DSN not configured. Disabling observability.")
            return
        }

        guard let environment = AppConfig.Sentry.environment else {
            Self.logger.warning(
                "Sentry environment not configured. Disabling observability."
            )
            return
        }

        let config = ObservabilityConfiguration(
            dsn: dsn,
            environment: environment,
            userID: userID
        )

        do {
            try await services.observabilityInitialiser.start(config)
        } catch {
            Self.logger.error(
                "Observability failed to initialise: \(error.localizedDescription, privacy: .public)"
            )
        }
    }

    /// Initialises feature flags. Mirrors `AppRootClient.liveValue.setupFeatureFlags`:
    /// returns early (logging) when Statsig is unconfigured, and rethrows any
    /// initialisation error (logged, then rethrown).
    private func setupFeatureFlags(userID: String) async throws {
        guard let apiKey = AppConfig.Statsig.sdkKey else {
            Self.logger.warning("Statsig SDK key not configured. Disabling feature flags.")
            return
        }

        guard let environment = AppConfig.Statsig.environment else {
            Self.logger.warning(
                "Statsig environment not configured. Disabling feature flags."
            )
            return
        }

        let config = FeatureFlagsConfiguration(
            apiKey: apiKey,
            environment: environment,
            userID: userID
        )

        do {
            try await services.featureFlagsInitialiser.start(config)
        } catch {
            Self.logger.error(
                "Feature flags failed to initialise: \(error.localizedDescription, privacy: .public)"
            )
            throw error
        }
    }

}

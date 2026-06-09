//
//  TVSeriesIntelligenceDependencies.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import IntelligenceDomain

/// The dependencies required by ``TVSeriesIntelligenceViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `TVSeriesIntelligenceClient` (`@DependencyClient`). Constructing it requires
/// every closure, so a missing dependency is a compile error. Build the
/// production instance with ``live(services:)``.
public struct TVSeriesIntelligenceDependencies: Sendable {

    public var fetchTVSeries: @Sendable (_ id: Int) async throws -> TVSeries
    public var createSession: @Sendable (_ tvSeriesID: Int) async throws -> any LLMSession
    public var captureError: @Sendable (_ error: any Error) -> Void

    public init(
        fetchTVSeries: @escaping @Sendable (_ id: Int) async throws -> TVSeries,
        createSession: @escaping @Sendable (_ tvSeriesID: Int) async throws -> any LLMSession,
        captureError: @escaping @Sendable (_ error: any Error) -> Void
    ) {
        self.fetchTVSeries = fetchTVSeries
        self.createSession = createSession
        self.captureError = captureError
    }

}

public extension TVSeriesIntelligenceDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `TVSeriesIntelligenceClient.liveValue` exactly: same use
    /// cases, same mapper. `captureError` reports to the shared observability
    /// service.
    static func live(services: AppServices) -> TVSeriesIntelligenceDependencies {
        let fetchTVSeriesDetails = services.tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
        let createTVSeriesIntelligenceSession = services.intelligenceFactory
            .makeCreateTVSeriesIntelligenceSessionUseCase()
        let observability = services.observability

        return TVSeriesIntelligenceDependencies(
            fetchTVSeries: { id in
                let tvSeries = try await fetchTVSeriesDetails.execute(id: id)
                let mapper = TVSeriesMapper()
                return mapper.map(tvSeries)
            },
            createSession: { tvSeriesID in
                try await createTVSeriesIntelligenceSession.execute(tvSeriesID: tvSeriesID)
            },
            captureError: { error in
                observability.capture(error: error)
            }
        )
    }

}

#if DEBUG
    public extension TVSeriesIntelligenceDependencies {

        /// Stub dependencies for previews and snapshot tests (mirrors the former
        /// `TVSeriesIntelligenceClient.previewValue`).
        static var preview: TVSeriesIntelligenceDependencies {
            TVSeriesIntelligenceDependencies(
                fetchTVSeries: { id in
                    TVSeries(id: id, name: "Stranger Things", tagline: "Strange things are afoot")
                },
                createSession: { _ in PreviewLLMSession() },
                captureError: { _ in }
            )
        }

    }

    /// A no-op ``LLMSession`` used by ``TVSeriesIntelligenceDependencies/preview``.
    private struct PreviewLLMSession: LLMSession {

        func respond(to _: String) async throws(LLMSessionError) -> String {
            "This is a preview response."
        }

    }
#endif

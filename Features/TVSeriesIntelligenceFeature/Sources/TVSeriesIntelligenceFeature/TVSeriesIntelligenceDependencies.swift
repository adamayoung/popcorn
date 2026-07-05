//
//  TVSeriesIntelligenceDependencies.swift
//  TVSeriesIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

/// The dependencies required by ``TVSeriesIntelligenceViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVSeriesIntelligenceViewModel``. Constructing it requires every closure,
/// so a missing dependency is a compile error. The production instance is built
/// by the app's composition layer; use ``preview`` for previews and tests.
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

#if DEBUG
    public extension TVSeriesIntelligenceDependencies {

        /// Stub dependencies for previews and snapshot tests.
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

//
//  MovieIntelligenceDependencies.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain

/// The dependencies required by ``MovieIntelligenceViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MovieIntelligenceViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct MovieIntelligenceDependencies: Sendable {

    public var fetchMovie: @Sendable (_ id: Int) async throws -> IntelligenceDomain.Movie
    public var createSession: @Sendable (_ movieID: Int) async throws -> any LLMSession
    public var captureError: @Sendable (_ error: any Error) -> Void

    public init(
        fetchMovie: @escaping @Sendable (_ id: Int) async throws -> IntelligenceDomain.Movie,
        createSession: @escaping @Sendable (_ movieID: Int) async throws -> any LLMSession,
        captureError: @escaping @Sendable (_ error: any Error) -> Void
    ) {
        self.fetchMovie = fetchMovie
        self.createSession = createSession
        self.captureError = captureError
    }

}

#if DEBUG
    public extension MovieIntelligenceDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MovieIntelligenceDependencies {
            MovieIntelligenceDependencies(
                fetchMovie: { id in
                    IntelligenceDomain.Movie(id: id, title: "Fight Club", overview: "")
                },
                createSession: { _ in PreviewLLMSession() },
                captureError: { _ in }
            )
        }

    }

    /// A stub session used by ``MovieIntelligenceDependencies/preview`` so previews
    /// and snapshots never reach the live LLM backend.
    private struct PreviewLLMSession: LLMSession {

        func respond(to prompt: String) async throws(LLMSessionError) -> String {
            "I'm your movie assistant."
        }

    }
#endif

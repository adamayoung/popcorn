//
//  MovieIntelligenceDependencies.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import IntelligenceApplication
import IntelligenceDomain
import MoviesApplication

/// The dependencies required by ``MovieIntelligenceViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `MovieIntelligenceClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
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

public extension MovieIntelligenceDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `MovieIntelligenceClient.liveValue` exactly: same use
    /// cases, same mapper. `captureError` reports through the shared observability
    /// service, matching the reducer's `@Dependency(\.observability).capture(error:)`.
    static func live(services: AppServices) -> MovieIntelligenceDependencies {
        let fetchMovieDetails = services.moviesFactory.makeFetchMovieDetailsUseCase()
        let createMovieIntelligenceSession = services.intelligenceFactory
            .makeCreateMovieIntelligenceSessionUseCase()

        return MovieIntelligenceDependencies(
            fetchMovie: { id in
                let movie = try await fetchMovieDetails.execute(id: id)
                return MovieMapper().map(movie)
            },
            createSession: { movieID in
                try await createMovieIntelligenceSession.execute(movieID: movieID)
            },
            captureError: { services.observability.capture(error: $0) }
        )
    }

}

#if DEBUG
    public extension MovieIntelligenceDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `MovieIntelligenceClient.previewValue`).
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

//
//  MovieIntelligenceClient.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import IntelligenceDomain

@DependencyClient
struct MovieIntelligenceClient: Sendable {

    var createSession: @Sendable (_ movieID: Int) async throws -> LLMSession

}

extension MovieIntelligenceClient: DependencyKey {

    static var liveValue: MovieIntelligenceClient {
        @Dependency(\.createMovieIntelligenceSession) var createMovieIntelligenceSession

        return MovieIntelligenceClient(
            createSession: { movieID in
                let session = try await createMovieIntelligenceSession.execute(movieID: movieID)
                return session
            }
        )
    }

}

extension DependencyValues {

    var movieIntelligenceClient: MovieIntelligenceClient {
        get {
            self[MovieIntelligenceClient.self]
        }
        set {
            self[MovieIntelligenceClient.self] = newValue
        }
    }

}

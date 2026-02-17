//
//  MovieIntelligenceClient.swift
//  MovieIntelligenceFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import IntelligenceDomain

@DependencyClient
struct MovieIntelligenceClient: Sendable {

    var fetchMovie: @Sendable (_ id: Int) async throws -> IntelligenceDomain.Movie
    var createSession: @Sendable (_ movieID: Int) async throws -> LLMSession

}

extension MovieIntelligenceClient: DependencyKey {

    static var liveValue: MovieIntelligenceClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.createMovieIntelligenceSession) var createMovieIntelligenceSession

        return MovieIntelligenceClient(
            fetchMovie: { id in
                let movie = try await fetchMovieDetails.execute(id: id)
                let mapper = MovieMapper()
                return mapper.map(movie)
            },
            createSession: { movieID in
                try await createMovieIntelligenceSession.execute(movieID: movieID)
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

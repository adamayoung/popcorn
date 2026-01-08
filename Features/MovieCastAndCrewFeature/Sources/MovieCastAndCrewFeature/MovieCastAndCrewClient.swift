//
//  MovieCastAndCrewClient.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation

@DependencyClient
struct MovieCastAndCrewClient: Sendable {

    var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits

}

extension MovieCastAndCrewClient: DependencyKey {

    static var liveValue: MovieCastAndCrewClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.fetchMovieCredits) var fetchMovieCredits

        return MovieCastAndCrewClient(
            fetchCredits: { movieID in
                let credits = try await fetchMovieCredits.execute(movieID: movieID)
                let mapper = CreditsMapper()
                return mapper.map(credits)
            }
        )
    }

    static var previewValue: MovieCastAndCrewClient {
        MovieCastAndCrewClient(
            fetchCredits: { _ in
                Credits.mock
            }
        )
    }

}

extension DependencyValues {

    var movieCastAndCrewClient: MovieCastAndCrewClient {
        get { self[MovieCastAndCrewClient.self] }
        set { self[MovieCastAndCrewClient.self] = newValue }
    }

}

//
//  MovieCastAndCrewClient.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import MoviesApplication

@DependencyClient
struct MovieCastAndCrewClient {

    var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits

}

extension MovieCastAndCrewClient: DependencyKey {

    static var liveValue: MovieCastAndCrewClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.fetchMovieCredits) var fetchMovieCredits

        return MovieCastAndCrewClient(
            fetchCredits: { movieID in
                do {
                    let credits = try await fetchMovieCredits.execute(movieID: movieID)
                    let mapper = CreditsMapper()
                    return mapper.map(credits)
                } catch let error as FetchMovieCreditsError {
                    throw FetchCreditsError(error)
                }
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

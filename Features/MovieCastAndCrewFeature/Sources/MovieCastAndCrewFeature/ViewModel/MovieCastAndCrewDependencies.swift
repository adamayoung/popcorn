//
//  MovieCastAndCrewDependencies.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import MoviesApplication

/// The dependencies required by ``MovieCastAndCrewViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MovieCastAndCrewViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. Build the production instance with ``live(services:)``.
public struct MovieCastAndCrewDependencies: Sendable {

    public var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits

    public init(
        fetchCredits: @escaping @Sendable (_ movieID: Int) async throws -> Credits
    ) {
        self.fetchCredits = fetchCredits
    }

}

public extension MovieCastAndCrewDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MovieCastAndCrewDependencies {
        let fetchMovieCredits = services.moviesFactory.makeFetchMovieCreditsUseCase()

        return MovieCastAndCrewDependencies(
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

}

#if DEBUG
    public extension MovieCastAndCrewDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MovieCastAndCrewDependencies {
            MovieCastAndCrewDependencies(
                fetchCredits: { _ in Credits.mock }
            )
        }

    }
#endif

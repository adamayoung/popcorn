//
//  StubMovieRecommendationRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubMovieRecommendationRepository: MovieRecommendationRepository, Sendable {

    public init() {}

    public func recommendations(
        forMovie movieID: Int,
        page: Int
    ) async throws(MovieRecommendationRepositoryError) -> [MoviePreview] {
        Self.recommendedMovies
    }

    public func recommendationsStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(Self.recommendedMovies)
            continuation.finish()
        }
    }

    public func recommendationsStream(
        forMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            let movies = limit.map { Array(Self.recommendedMovies.prefix($0)) } ?? Self.recommendedMovies
            continuation.yield(movies)
            continuation.finish()
        }
    }

    public func nextRecommendationsStreamPage(
        forMovie movieID: Int
    ) async throws(MovieRecommendationRepositoryError) {
        // No-op for stub
    }

}

extension StubMovieRecommendationRepository {

    // swiftlint:disable line_length
    static let recommendedMovies: [MoviePreview] = [
        MoviePreview(
            id: 967_941,
            title: "Wicked: For Good",
            overview: "As an angry mob rises against the Wicked Witch, Glinda and Elphaba will need to come together one final time.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 19).date,
            posterPath: URL(string: "/si9tolnefLSUKaqQEGz1bWArOaL.jpg"),
            backdropPath: URL(string: "/l8pwO23MCvqYumzozpxynCNfck1.jpg")
        ),
        MoviePreview(
            id: 425_274,
            title: "Now You See Me: Now You Don't",
            overview: "The original Four Horsemen reunite with a new generation of illusionists.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 12).date,
            posterPath: URL(string: "/oD3Eey4e4Z259XLm3eD3WGcoJAh.jpg"),
            backdropPath: URL(string: "/dHSz0tSFuO2CsXJ1CApSauP9Ncl.jpg")
        ),
        MoviePreview(
            id: 1_317_288,
            title: "Marty Supreme",
            overview: "In 1950s New York, table tennis player Marty Mauser goes to Hell and back in pursuit of greatness.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 12, day: 19).date,
            posterPath: URL(string: "/firAhZA0uQvRL2slp7v3AnOj0ZX.jpg"),
            backdropPath: URL(string: "/qKWDHofjMHPSEOTLaixkC9ZmjTT.jpg")
        ),
        MoviePreview(
            id: 1_054_867,
            title: "One Battle After Another",
            overview: "Washed-up revolutionary Bob exists in a state of stoned paranoia, surviving off-grid with his spirited, self-reliant daughter.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 9, day: 23).date,
            posterPath: URL(string: "/r4uXvqCeco0KmO0CjlhXuTEFuSE.jpg"),
            backdropPath: URL(string: "/zpEWFNqoN8Qg1SzMMHmaGyOBTdW.jpg")
        )
    ]
    // swiftlint:enable line_length

}

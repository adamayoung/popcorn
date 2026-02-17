//
//  StubSimilarMovieRepository.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain

public final class StubSimilarMovieRepository: SimilarMovieRepository, Sendable {

    public init() {}

    public func similar(
        toMovie movieID: Int,
        page: Int
    ) async throws(SimilarMovieRepositoryError) -> [MoviePreview] {
        Self.similarMovies
    }

    public func similarStream(
        toMovie movieID: Int
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            continuation.yield(Self.similarMovies)
            continuation.finish()
        }
    }

    public func similarStream(
        toMovie movieID: Int,
        limit: Int?
    ) async -> AsyncThrowingStream<[MoviePreview]?, Error> {
        AsyncThrowingStream { continuation in
            let movies = limit.map { Array(Self.similarMovies.prefix($0)) } ?? Self.similarMovies
            continuation.yield(movies)
            continuation.finish()
        }
    }

    public func nextSimilarStreamPage(forMovie movieID: Int) async throws(SimilarMovieRepositoryError) {
        // No-op for stub
    }

}

extension StubSimilarMovieRepository {

    // swiftlint:disable line_length
    static let similarMovies: [MoviePreview] = [
        MoviePreview(
            id: 533_533,
            title: "TRON: Ares",
            overview: "A highly sophisticated Program called Ares is sent from the digital world into the real world on a dangerous mission.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 8).date,
            posterPath: URL(string: "/chpWmskl3aKm1aTZqUHRCtviwPy.jpg"),
            backdropPath: URL(string: "/min9ZUDZbiguTiQ7yz1Hbqk78HT.jpg")
        ),
        MoviePreview(
            id: 1_062_722,
            title: "Frankenstein",
            overview: "Dr. Victor Frankenstein, a brilliant but egotistical scientist, brings a creature to life in a monstrous experiment.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 10, day: 17).date,
            posterPath: URL(string: "/g4JtvGlQO7DByTI6frUobqvSL3R.jpg"),
            backdropPath: URL(string: "/ceyakefyCRAgyeFhefa2bz6d9QO.jpg")
        ),
        MoviePreview(
            id: 812_583,
            title: "Wake Up Dead Man: A Knives Out Mystery",
            overview: "Renowned detective Benoit Blanc unravels a mystery that defies all logic.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 11, day: 26).date,
            posterPath: URL(string: "/qCOGGi8JBVEZMc3DVby8rUivyXz.jpg"),
            backdropPath: URL(string: "/fiRDzpcJe7qz3yIR43hdXIE3NHv.jpg")
        )
    ]
    // swiftlint:enable line_length

}

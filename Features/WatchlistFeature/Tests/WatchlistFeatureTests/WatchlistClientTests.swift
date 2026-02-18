//
//  WatchlistClientTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import CoreDomain
import Foundation
import MoviesApplication
import Testing
@testable import WatchlistFeature

@Suite("WatchlistClient Tests")
struct WatchlistClientTests {

    @Test("fetchWatchlistMovies maps use case result to movie previews")
    func fetchWatchlistMoviesMapsUseCaseResult() async throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let moviePreviewDetails = [
            MoviePreviewDetails(
                id: 1,
                title: "Movie 1",
                overview: "Overview 1",
                posterURLSet: posterURLSet
            ),
            MoviePreviewDetails(
                id: 2,
                title: "Movie 2",
                overview: "Overview 2"
            )
        ]

        let client = withDependencies {
            $0.fetchWatchlistMovies = MockFetchWatchlistMoviesUseCase(
                result: moviePreviewDetails
            )
            $0.streamWatchlistMovies = MockStreamWatchlistMoviesUseCase()
        } operation: {
            WatchlistClient.liveValue
        }

        let result = try await client.fetchWatchlistMovies()

        #expect(result.count == 2)
        #expect(result[0].id == 1)
        #expect(result[0].title == "Movie 1")
        #expect(result[0].posterURL == URL(string: "https://example.com/thumbnail.jpg"))
        #expect(result[1].id == 2)
        #expect(result[1].title == "Movie 2")
        #expect(result[1].posterURL == nil)
    }

    @Test("streamWatchlistMovies maps use case stream to movie previews")
    func streamWatchlistMoviesMapsStream() async throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let moviePreviewDetails = [
            MoviePreviewDetails(
                id: 1,
                title: "Movie 1",
                overview: "Overview 1",
                posterURLSet: posterURLSet
            ),
            MoviePreviewDetails(
                id: 2,
                title: "Movie 2",
                overview: "Overview 2"
            )
        ]

        let client = withDependencies {
            $0.fetchWatchlistMovies = MockFetchWatchlistMoviesUseCase(result: [])
            $0.streamWatchlistMovies = MockStreamWatchlistMoviesUseCase(
                emissions: [moviePreviewDetails]
            )
        } operation: {
            WatchlistClient.liveValue
        }

        let stream = try await client.streamWatchlistMovies()

        var results: [[MoviePreview]] = []
        for try await value in stream {
            results.append(value)
        }

        #expect(results.count == 1)
        #expect(results[0].count == 2)
        #expect(results[0][0].id == 1)
        #expect(results[0][0].title == "Movie 1")
        #expect(results[0][0].posterURL == URL(string: "https://example.com/thumbnail.jpg"))
        #expect(results[0][1].id == 2)
        #expect(results[0][1].title == "Movie 2")
        #expect(results[0][1].posterURL == nil)
    }

}

private struct MockFetchWatchlistMoviesUseCase: FetchWatchlistMoviesUseCase {

    let result: [MoviePreviewDetails]

    func execute() async throws(FetchWatchlistMoviesError) -> [MoviePreviewDetails] {
        result
    }

}

private struct MockStreamWatchlistMoviesUseCase: StreamWatchlistMoviesUseCase {

    let emissions: [[MoviePreviewDetails]]

    init(emissions: [[MoviePreviewDetails]] = []) {
        self.emissions = emissions
    }

    func stream() async -> AsyncThrowingStream<[MoviePreviewDetails], Error> {
        AsyncThrowingStream { continuation in
            for emission in emissions {
                continuation.yield(emission)
            }
            continuation.finish()
        }
    }

}

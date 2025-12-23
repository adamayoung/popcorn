//
//  MovieImagesToolTests.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
import Testing

@Suite("MovieImagesTool Tests")
struct MovieImagesToolTests {

    @Test("Tool should have correct name and description")
    func toolProperties() {
        let tool = MovieImagesTool(
            movieID: 123,
            movieImageRepository: MockMovieImageRepository()
        )

        #expect(tool.name == "getMovieImages")
        #expect(!tool.description.isEmpty)
    }

    @Test("Tool should return poster URLs when requested")
    func callReturnsPosterURLs() async throws {
        let mockImageCollection = try ImageCollection(
            id: 550,
            posterPaths: [
                #require(URL(string: "/poster1.jpg")),
                #require(URL(string: "/poster2.jpg"))
            ],
            backdropPaths: [],
            logoPaths: []
        )
        let mockRepository = MockMovieImageRepository(imageCollectionToReturn: mockImageCollection)

        let tool = MovieImagesTool(
            movieID: 550,
            movieImageRepository: mockRepository
        )

        let result = try await tool.call(arguments: MovieImagesTool.Arguments(imageType: "poster"))

        #expect(result.contains("/poster1.jpg"))
        #expect(result.contains("/poster2.jpg"))
    }

    @Test("Tool should return backdrop URLs when requested")
    func callReturnsBackdropURLs() async throws {
        let mockImageCollection = try ImageCollection(
            id: 550,
            posterPaths: [],
            backdropPaths: [
                #require(URL(string: "/backdrop1.jpg"))
            ],
            logoPaths: []
        )
        let mockRepository = MockMovieImageRepository(imageCollectionToReturn: mockImageCollection)

        let tool = MovieImagesTool(
            movieID: 550,
            movieImageRepository: mockRepository
        )

        let result = try await tool.call(arguments: MovieImagesTool.Arguments(imageType: "backdrop"))

        #expect(result.contains("/backdrop1.jpg"))
    }

}

// MARK: - Mock MovieImageRepository

private final class MockMovieImageRepository: MovieImageRepository {

    private let imageCollectionToReturn: ImageCollection?
    private let shouldThrow: Bool

    init(imageCollectionToReturn: ImageCollection? = nil, shouldThrow: Bool = false) {
        self.imageCollectionToReturn = imageCollectionToReturn
        self.shouldThrow = shouldThrow
    }

    func imageCollection(forMovie movieID: Int) async throws(MovieImageRepositoryError) -> ImageCollection {
        if shouldThrow {
            throw .notFound
        }

        guard let collection = imageCollectionToReturn else {
            throw .notFound
        }

        return collection
    }

    func imageCollectionStream(
        forMovie movieID: Int
    ) async -> AsyncThrowingStream<ImageCollection?, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }

}

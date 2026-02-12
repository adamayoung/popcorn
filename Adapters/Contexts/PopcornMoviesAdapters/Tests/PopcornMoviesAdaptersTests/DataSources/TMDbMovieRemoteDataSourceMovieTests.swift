//
//  TMDbMovieRemoteDataSourceMovieTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("TMDbMovieRemoteDataSource Movie Tests")
struct TMDbMovieRemoteDataSourceMovieTests {

    let mockService: MockMoviesService

    init() {
        self.mockService = MockMoviesService()
    }

    @Test("movie maps response and uses en language")
    func movie_mapsResponseAndUsesEnglishLanguage() async throws {
        let id = 550
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let releaseDate = Date(timeIntervalSince1970: 939_686_400)

        let tmdbMovie = TMDb.Movie(
            id: id,
            title: "Fight Club",
            tagline: "Mischief. Mayhem. Soap.",
            overview: "A ticking-time-bomb insomniac",
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath
        )

        mockService.detailsStub = .success(tmdbMovie)

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.movie(withID: id)

        #expect(result.id == 550)
        #expect(result.title == "Fight Club")
        #expect(result.tagline == "Mischief. Mayhem. Soap.")
        #expect(mockService.detailsCallCount == 1)
        #expect(mockService.detailsCalledWith[0] == .init(id: id, language: "en"))
    }

    @Test("movie throws notFound error for TMDb notFound")
    func movie_throwsNotFoundErrorForTMDbNotFound() async {
        let id = 550

        mockService.detailsStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.movie(withID: id)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .notFound = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movie throws unauthorised error for TMDb unauthorised")
    func movie_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let id = 550

        mockService.detailsStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.movie(withID: id)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unauthorised = error {
                    return true
                }

                return false
            }
        )
    }

    @Test("movie throws unknown error for non mapped TMDb error")
    func movie_throwsUnknownErrorForNonMappedTMDbError() async {
        let id = 550

        mockService.detailsStub = .failure(.network(TestError()))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.movie(withID: id)
            },
            throws: { error in
                guard let error = error as? MovieRemoteDataSourceError else {
                    return false
                }

                if case .unknown = error {
                    return true
                }

                return false
            }
        )
    }

}

private extension TMDbMovieRemoteDataSourceMovieTests {

    struct TestError: Error {}

}

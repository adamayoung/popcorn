//
//  TMDbMovieRemoteDataSourceImagesTests.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import MoviesInfrastructure
@testable import PopcornMoviesAdapters
import Testing
import TMDb

@Suite("TMDbMovieRemoteDataSource Images Tests")
struct TMDbMovieRemoteDataSourceImagesTests {

    let mockService: MockMoviesService

    init() {
        self.mockService = MockMoviesService()
    }

    @Test("imageCollection maps response and uses en language filter")
    func imageCollection_mapsResponseAndUsesEnglishFilter() async throws {
        let movieID = 550
        let poster = try makeImageMetadata(path: "https://tmdb.example/poster.jpg")
        let backdrop = try makeImageMetadata(path: "https://tmdb.example/backdrop.jpg")
        let logo = try makeImageMetadata(path: "https://tmdb.example/logo.jpg")

        mockService.imagesStub = .success(
            ImageCollection(
                id: movieID,
                posters: [poster],
                logos: [logo],
                backdrops: [backdrop]
            )
        )

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        let result = try await dataSource.imageCollection(forMovie: movieID)

        #expect(result.id == movieID)
        #expect(result.posterPaths == [poster.filePath])
        #expect(result.backdropPaths == [backdrop.filePath])
        #expect(result.logoPaths == [logo.filePath])
        #expect(mockService.imagesCallCount == 1)
        #expect(mockService.imagesCalledWith[0].filter?.languages == ["en"])
    }

    @Test("imageCollection throws notFound error for TMDb notFound")
    func imageCollection_throwsNotFoundErrorForTMDbNotFound() async {
        let movieID = 550

        mockService.imagesStub = .failure(.notFound())

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.imageCollection(forMovie: movieID)
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

    @Test("imageCollection throws unauthorised error for TMDb unauthorised")
    func imageCollection_throwsUnauthorisedErrorForTMDbUnauthorised() async {
        let movieID = 550

        mockService.imagesStub = .failure(.unauthorised("No access"))

        let dataSource = TMDbMovieRemoteDataSource(movieService: mockService)

        await #expect(
            performing: {
                try await dataSource.imageCollection(forMovie: movieID)
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

}

private extension TMDbMovieRemoteDataSourceImagesTests {

    func makeImageMetadata(path: String) throws -> ImageMetadata {
        try ImageMetadata(
            filePath: #require(URL(string: path)),
            width: 300,
            height: 450,
            aspectRatio: 0.66,
            voteAverage: nil,
            voteCount: nil
        )
    }

}
